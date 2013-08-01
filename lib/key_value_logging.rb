require "key_value_logging/version"
require "key_value_logging/tagged_logging"
require "key_value_logging/logger_middleware"

require 'key_value_logging/railtie' if defined?(Rails)

module KeyValueLogging
  # init namespace
end
