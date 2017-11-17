# frozen_string_literal: true

module ActiveJobReporter
  module_function

  def configuration
    @configuration ||= Configuration.new
  end

  def configure
    configuration.instance_eval(&Proc.new)
  end
end
