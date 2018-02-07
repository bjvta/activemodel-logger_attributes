# ActiveModel::LoggerAttributes

This gem provides a convenient way to save `Logger` messages to an attribute on your model. Multiple logger attributes are supported.

You may be also be interested in the (ActiveRecord version)[https://github.com/chrisb/activerecord-logger_attributes].

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activemodel-logger_attributes', '~> 0.1.1'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activemodel-logger_attributes

## Usage

Your attribute should ideally be an `Array` or anything that responds to `<<`.

Defining the attribute is straightforward with `logger_attr`.

```ruby
class Book
  include ActiveModel::Model

  logger_attr :activity_log

  # expanded version with defaults:
  # logger_attr :activity_log, logger_class: ::Logger, logger_name: :activity_log_logger, logger_init: -> {}
end
```

If you prefer selectively mixing in functionality, simply `include ActiveModel::LoggerAttributes`. If you have multiple logger attributes take care to avoid clobbering logger names.

```ruby
book = Book.new # previous log history is supported: Book.new activity_log: [..]
book.activity_log_logger.info 'Finished initializing book'
book.activity_log_logger.error 'Something went wrong!'
book.activity_log # => ["I, [2018-02-05T09:59:37.871594 #34988]  INFO -- : Finished initializing book", "E, [2018-02-05T09:59:37.871960 #34988] ERROR -- : Something went wrong!"]
```

As you would expect `book.activity_log_logger` is an instance of `Logger`.

By default, `logger_attr` will use `Logger` for the log class the logger's name; additionally, the logger `progname` will be set to your model's class name and attribute. Passing a block to `logger_init` is a convenient way to perform custom initialization on your logger's class. You may wish to override the default `progname` or perhaps set a log level:

```ruby
logger_attr :activity_log, logger_init: ->(l) { l.level = Logger::WARN }
```
