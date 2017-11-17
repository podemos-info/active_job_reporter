# frozen_string_literal: true

ActiveJobReporter.configure do |config|
  config.jobs_table_name = "jobs"
  config.user_class_name = "User"
end
