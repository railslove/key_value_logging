require 'rails'

module KeyValueLogging
  class LoggerMiddleware < Rails::Rack::Logger
    def compute_tags(request)
      tag_value_pairs = @taggers.map do |tag, key_or_proc|
        value = case key_or_proc
        when Proc
          key_or_proc.call(request)
        when Symbol
          request.send(key_or_proc)
        else
          key_or_proc
        end
        [tag, value]
      end
      Hash[*tag_value_pairs.flatten]
    end
  end
end