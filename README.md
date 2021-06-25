# Google Logger

This gem simplifies controller requests logging by providing a wrapper around the [stackdriver gem](https://github.com/googleapis/google-cloud-ruby/tree/master/stackdriver).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'google_logger'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install google_logger

## Configuration

The best way to configure GoogleLogger is to create a new file in 'config/initializers', `project_id` and `credentials` are required, the other configuration values are optional.

```ruby
require 'google_logger'

GoogleLogger.configure do |config|
    config.project_id = 'project_id'
    config.credentials = 'path_to_keyfile' # path to keyfile or hash with credentials
    config.async = true
    config.resource_type = 'gae_app'
    config.resource_labels = {}
    config.secret_params = %i[password]
    config.secret_param_value = '<SECRET_PARAM>'
end
```

If `log_locally` is set to `true`, then credentials are not required, however `local_logger` which will be used to write logs must be supplied and it must respond to the same interface as `ActionSupport::Logger`.

```ruby
GoogleLogger.configure do |config|
    config.log_locally = true
    config.local_logger = ActiveSupport::Logger.new("log/google_log_#{Rails.env}.log")
end
```

This option is useful if you want to log to cloud only in specific environments.

The whole configuration is stored in the `GoogleLogger` module and can be accessed and/or changed at any time.

```ruby
config = GoogleLogger.configuration # returns GoogleLogger::Configuration
config.secret_params << :username
config.project_id = 'another_project_id'
```
## Usage

### Creating logs

The simpest way to create logs is using the `GoogleLogger::create_entry` method.

```ruby
# logging a string
string_payload = 'a simple log text'
GoogleLogger.create_entry(string_payload, log_name: 'default_log', severity: :DEFAULT)

# logging a complex object
hash_payload = { some_text: 'log message', any_aray: [1, 2, 3], another_hash: { a: 1 } }
GoogleLogger.create_entry(hash_payload)
```

It is also possible to manually create the log entries:

```ruby
logger = GoogleLogger.logger
entry = logger.build_entry('string payload')
logger.write_entry(entry)
```
### Controller logging

The `GoogleLogger::ControllerLogging` concern provides `log_request_to_google` method which allows you to easily log requests. The method works as an `around_action` filter, so that it can easily be turned on or off for each method. If you decide to log every request in your application, you can easily do so like this:

```ruby
class ApplicationController < ActionController::Base
    include GoogleLogger::ControllerLogging

    # log every request
    around_action: :log_request_to_google
end
```

And if you decide not to log requests for a specific controller or action, you can turn the logging off as you would turn off any other filter:

```ruby
class NoLoggingController < ApplicationController
    skip_around_action: :log_request_to_google
end

class SpecificLoggingController < ApplicationController
    skip_around_action: :log_request_to_google, only: :no_log_request
end
```

The concern automatically logs the request target URL, client ip address, request method and params.
By default, all params are logged. Params whose value should not be logged can be configured in `secret_params`, their value is then replaced by `secret_param_value`, which by default is `'<SECRET_PARAM>'`. You can specify which params should or should not be logged by overriding the `google_log_params` method in your controller, in which case the return value of this method will be logged as params.
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/google_logger.

## Sponsors

Special thanks goes to [Panter](https://www.panter.ch/home) and [Yova](https://inyova.ch) for sponsoring development of this gem.

![](https://github.com/panter/google_logger/logos/panter.svg)
![](https://github.com/panter/google_logger/logos/yova.svg)

