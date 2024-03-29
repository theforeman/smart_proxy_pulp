# frozen_string_literal: true

module PulpProxy
  module Validators
    class Include < ::Proxy::PluginValidators::Base
      def validate!(settings)
        setting_value = settings[@setting_name]
        return true if (setting_value - @params).empty?

        # rubocop:disable Layout/LineLength
        raise ::Proxy::Error::ConfigurationError, "Parameter '#{@setting_name}' is expected to be one or more of #{@params}"
        # rubocop:enable Layout/LineLength
      end
    end
  end
end
