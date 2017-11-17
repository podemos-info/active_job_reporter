# frozen_string_literal: true

require "active_support/concern"

module ActiveJobReporter
  module ReportableJob
    extend ::ActiveSupport::Concern

    included do
      before_enqueue do |job|
        job.update_status(:enqueued)
      end

      around_perform do |job, block|
        job.update_status(:running)
        begin
          job.result = :ok
          block.call
        rescue StandardError => err
          job.log :error, raw: err.message
          job.result = :error
          raise
        ensure
          job.update_status(:finished)
        end
      end
    end

    def update_status(status)
      job_record.status = status
      job_record.save
    end

    def result
      job_record.result.to_sym
    end

    def result=(result)
      job_record.result = result
    end

    def log(type, **message)
      job_record.add_message type: type, message: message
    end

    private

    def job_record
      @job_record ||= ActiveJobReporter::Job.find_or_initialize_by(job_id: job_id) do |job_record|
        job_record.job_type = self.class.name
        job_record.user = current_user if respond_to? :current_user
        if respond_to? :related_objects
          (related_objects || []).each do |object|
            job_record.job_objects.build(object: object)
          end
        end
      end
    end
  end
end
