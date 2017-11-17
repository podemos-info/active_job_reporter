# frozen_string_literal: true

require "rails_helper"
require "generator_spec/test_case"
require File.expand_path("../../../lib/generators/active_job_reporter/install_generator", __FILE__)

RSpec.describe ActiveJobReporter::InstallGenerator, type: :generator do
  include GeneratorSpec::TestCase
  destination File.expand_path("../tmp", __FILE__)

  after(:all) { prepare_destination } # cleanup the tmp directory

  describe "no options" do
    before(:all) do
      prepare_destination
      run_generator
    end

    it "generates a migration for creating the 'jobs' table" do
      expect(destination_root).to(
        have_structure do
          directory("db") do
            directory("migrate") do
              migration("create_jobs") do
                contains "class CreateJobs"
                contains "def change"
                contains "create_table :jobs"
                contains "create_table :job_objects"
                contains "create_table :job_messages"
              end
            end
          end
        end
      )
    end

    it "generates an initializer" do
      expect(destination_root).to(
        have_structure do
          directory("config") do
            directory("initializers") do
              file("active_job_reporter.rb") do
                contains "config.jobs_table_name = \"jobs\""
              end
            end
          end
        end
      )
    end
  end

  describe "`--jobs-table-name` option changed" do
    before(:all) do
      prepare_destination
      run_generator %w(--jobs-table-name=active_jobs)
    end

    it "generates a migration for creating the 'active_jobs' table" do
      expect(destination_root).to(
        have_structure do
          directory("db") do
            directory("migrate") do
              migration("create_jobs") do
                contains "class CreateJobs"
                contains "def change"
                contains "create_table :active_jobs"
                contains "create_table :active_job_objects"
                contains "create_table :active_job_messages"
              end
            end
          end
        end
      )
    end

    it "generates an initializer" do
      expect(destination_root).to(
        have_structure do
          directory("config") do
            directory("initializers") do
              file("active_job_reporter.rb") do
                contains "config.jobs_table_name = \"active_jobs\""
              end
            end
          end
        end
      )
    end
  end
end
