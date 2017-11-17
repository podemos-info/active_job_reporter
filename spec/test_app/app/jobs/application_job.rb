# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base
  include ActiveJobReporter::ReportableJob

  def current_user
    arguments.first&.fetch(:admin_user, nil)
  end
end
