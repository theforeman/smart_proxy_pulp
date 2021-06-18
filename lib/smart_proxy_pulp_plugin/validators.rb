module PulpProxy
  module Validators
    class Include < ::Proxy::PluginValidators::Base
      def validate!(settings)
        setting_value = settings[@setting_name]

        unless (setting_value - @params).empty?
          raise ::Proxy::Error::ConfigurationError, "Parameter '#{@setting_name}' is expected to be one or more of #{@params}"
        else
          true
        end
      end
    end
  end
end
