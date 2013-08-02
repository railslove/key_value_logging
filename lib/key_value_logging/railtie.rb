module KeyValueLogging
  class KeyValueLoggingRailtie < Rails::Railtie

    # Default options for the key value logger
    config.key_value_logging = ActiveSupport::OrderedOptions.new
    config.key_value_logging.tags = {}
    config.key_value_logging.format = :default
    config.key_value_logging.formatter = nil

    # Add custom logging middleware, after the logger is initialized
    initializer "key_value_logging_railtie.configure_rails_initialization", after: :initialize_logger do |app|
      if defined?(ActiveSupport::BufferedLogger)
        # Apply monkey patch to BufferedLogger to allow to set a formatter
        require 'formatted_rails_logger'
        FormattedRailsLogger.patch_rails
      end

      logger = Rails.logger

      # If provided, set the custom formatter
      if config.key_value_logging.formatter.present?
        logger.formatter = config.key_value_logging.formatter
      end

      # Extend the logger with key value logging
      Rails.logger = KeyValueLogging::TaggedLogging.new(logger, config.key_value_logging.format)

      # Replace the default rails with thw key value logger middleware
      app.middleware.delete(Rails::Rack::Logger)
      app.middleware.use KeyValueLogging::LoggerMiddleware, config.key_value_logging.tags
    end
  end
end
