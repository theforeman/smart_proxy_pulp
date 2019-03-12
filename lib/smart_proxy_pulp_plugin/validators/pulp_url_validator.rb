module PulpProxy
  module Validators
    class PulpUrlValidator < ::Proxy::PluginValidators::Base
      def validate!(settings)
        raise ::Proxy::Error::ConfigurationError, "Setting 'pulp_url' is expected to contain a url for pulp server" if settings[:pulp_url].to_s.empty?
        URI.parse(settings[:pulp_url])
      rescue URI::InvalidURIError
        raise ::Proxy::Error::ConfigurationError.new("Setting 'pulp_url' contains an invalid url for pulp server")
      end
    end
  end
end
