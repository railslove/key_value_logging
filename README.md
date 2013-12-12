# KeyValueLogging

Replacement for the Rails TaggedLogging using key-value pairs instead of flat tags. 
This allows you to add more data to your log output. 


## Installation

Add this line to your application's Gemfile:

    gem 'key_value_logging'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install key_value_logging

## Environment specific configuration

Add tag to all requests:

    # By referencing a request object method
    config.key_value_logging.tags = { uuid: :uuid }

    # By providing a proc
    config.key_value_logging.tags = { params: ->(request){ request.filtered_params } }

    # By providing flat data
    config.key_value_logging.tags = { mydata: 'Fixed string' }

By default the key value tags are rendered like ```key=value```. But you may
need to preprocess them. In order to make your life easier, you can access all
data as a hash by setting the raw format option. The log message itself will be
available at the ```:message``` key:

    config.key_value_logging.format = :raw

Especially in combination with the raw format option, it makes sense to set your
own formatter. This could post-process the raw tags and data. As we extend the
logger and formatter, we provide an easy way to set yout own formatter while
taking advantage of the custom key-value behaviour:

    config.key_value_logging.formatter = YourCustomLogFormatter.new

## In-app usage

Like the default rails TaggedLogging logger, you can tag log messages with this
logger. The syntax is almost the same. But instead of providing flat strings, you
now provide a hash with key and value:

    logger.tagged(city: 'Cologne', country: 'Cologne') { logger.info 'made with love' }

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

This gem is released under the [MIT License](http://www.opensource.org/licenses/MIT).
