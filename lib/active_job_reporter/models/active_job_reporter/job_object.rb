# frozen_string_literal: true

module ActiveJobReporter
  class JobObject < ActiveRecord::Base
    belongs_to :job
    belongs_to :object, polymorphic: true
  end
end
