require 'logger'
require 'active_support/all'

# Wraps any standard Logger object to provide tagging capabilities.
#
#   logger = KeyValueTaggedLogging.new(Logger.new(STDOUT))
#   logger.tagged('location' => 'Cologne') { logger.info 'Stuff' } # Logs "Stuff location=Cologne"
module KeyValueLogging
  module TaggedLogging
    module Formatter # :nodoc:
      attr_accessor :key_value_format

      # This method is invoked when a log event occurs.
      def call(severity, timestamp, progname, msg)
        formatted_msg = self.send("process_#{key_value_format}", msg)
        super(severity, timestamp, progname, formatted_msg)
      end

      def tagged(tags)
        # Add temporary tags to current tags
        new_tags = push_tags(tags)
        yield self
      ensure
        # Remove the temporary tags from current tags
        pop_tags(tags.keys)
      end

      def push_tags(tags)
        tags.tap do |new_tags|
          current_tags.merge! new_tags
        end
      end

      def pop_tags(keys)
        keys.each { |key| current_tags.delete(key) }
      end

      def clear_tags!
        current_tags.clear
      end

      def current_tags
        Thread.current[:key_value_tagged_logging_tags] ||= {}
      end

      private

      def process_default(msg)
        tags = current_tags.map { |key, value| "#{key}=#{value}" }
        [msg, tags].flatten.compact.join(' ')
      end

      def process_raw(msg)
        if msg.kind_of?(Hash)
          current_tags.merge(msg)
        else
          current_tags.merge(message: msg)
        end
      end
    end

    def self.new(logger, key_value_format = 'default')
      yield(logger) if block_given?
      # Ensure we set a default formatter so we aren't extending nil!
      logger.formatter ||= ActiveSupport::Logger::SimpleFormatter.new
      logger.formatter.extend Formatter
      logger.formatter.key_value_format = key_value_format
      logger.extend(self)
    end

    delegate :push_tags, :pop_tags, :clear_tags!, to: :formatter

    def tagged(tags = {})
      formatter.tagged(tags) { yield self }
    end

    def flush
      clear_tags!
      super if defined?(super)
    end
  end
end