# frozen_string_literal: true

module ActiveJobReporter
  class Configuration
    attr_accessor :jobs_table_name, :user_class_name, :job_class_name

    def user_class
      @user_class ||= user_class_name.constantize
    end
  end
end
