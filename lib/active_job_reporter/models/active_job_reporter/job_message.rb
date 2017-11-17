# frozen_string_literal: true

module ActiveJobReporter
  class JobMessage < ActiveRecord::Base
    store :message, coder: JSON

    belongs_to :job

    validates :message_type, :message, presence: true
  end
end
