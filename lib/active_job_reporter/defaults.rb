# frozen_string_literal: true

ActiveJobReporter.configure do |config|
  config.jobs_table_name = "jobs"
  config.user_class_name = "User"
  config.job_class_name = "ActiveJobReporter::Job"
end
