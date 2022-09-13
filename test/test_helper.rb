# frozen_string_literal: true

require "test/unit"
$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')

require 'smart_proxy_for_testing'

# create log directory in our (not smart-proxy) directory
FileUtils.mkdir_p File.dirname(Proxy::SETTINGS.log_file)
