# frozen_string_literal: true

ActiveJobReporter.configure do |config|
  config.jobs_table_name = "jobs"

  # The class for users that will launch jobs
  # config.user_class_name = "User"
end
