# frozen_string_literal: true

module ActiveJobReporter
  class Job < ActiveRecord::Base
    include ActiveJobReporter::JobConcern
  end
end
