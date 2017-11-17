# frozen_string_literal: true

require "rails/generators"
require "rails/generators/active_record"

module ActiveJobReporter
  # Installs ActiveJobReporter in a rails app.
  class InstallGenerator < ::Rails::Generators::Base
    include ::Rails::Generators::Migration

    source_root File.expand_path("../templates", __FILE__)

    class_option(
      :jobs_table_name,
      type: :string,
      default: "jobs",
      desc: "Jobs table name, `jobs` by default."
    )

    desc "Generates an initializer file for configuring ActiveJobReporter." \
         "Also generates a migration to add jobs tables."

    def create_migration_file
      migration_template "create_jobs.rb.erb", File.join("db", "migrate", "create_jobs.rb")
    end

    def create_initializer
      template "active_job_reporter.rb.erb", File.join("config", "initializers", "active_job_reporter.rb")
    end

    def self.next_migration_number(dirname)
      ::ActiveRecord::Generators::Base.next_migration_number(dirname)
    end

    def migration_version
      "[#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}]"
    end

    def jobs_table_name
      options.jobs_table_name
    end
  end
end
