require 'logger'
require 'active_model'
require 'active_model/logger_attributes/version'
require 'active_model/logger_attributes/device'

module ActiveModel
  module LoggerAttributes
    extend ActiveSupport::Concern

    InvalidAttributeValue = Class.new(RuntimeError)

    module ClassMethods
      def logger_attr_default_options
        { logger_class: ::Logger, logger_name: nil, logger_init: ->(l) {} }
      end

      def setup_logger_attr(attribute, options)
        @logger_attributes ||= {}
        @logger_attributes[attribute] = logger_attr_default_options.merge(options)
        @logger_attributes[attribute][:logger_name] ||= "#{attribute}_logger"
        define_logger_attr_initializer(attribute)
        define_logger_attr_accessor(attribute)
      end

      def logger_attr(attribute, options = {})
        attribute = attribute.to_sym
        setup_logger_attr(attribute, options)
        attr_accessor(attribute)
      end

      def define_logger_attr_initializer(attribute)
        options = @logger_attributes[attribute]
        define_method(:"initialize_#{options[:logger_name]}") do
          define_attr_logger_attribute(attribute)
          logger = logger_for_logger_attribute(attribute, options[:logger_class], &options[:logger_init])
          instance_variable_set :"@#{options[:logger_name]}", logger
        end
      end

      def define_logger_attr_accessor(attribute)
        options = @logger_attributes[attribute]
        define_method(options[:logger_name]) do
          instance_variable_get(:"@#{options[:logger_name]}") || send(:"initialize_#{options[:logger_name]}")
        end
      end
    end

    def logger_for_logger_attribute(attribute, logger_class, &block)
      device = ActiveModel::LoggerAttributes::Device.new(attribute, self)
      logger_class.new(device).tap do |l|
        l.progname = "#{self.class.name}.#{attribute}" if l.respond_to?(:progname)
        yield l if block_given?
      end
    end

    # ensure the attribute itself has been initialized...
    def define_attr_logger_attribute(attribute)
      instance_variable_set(:"@#{attribute}", []) unless instance_variable_get(:"@#{attribute}")
      return if instance_variable_get(:"@#{attribute}").respond_to?(:<<)
      raise InvalidAttributeValue, "invalid type for attribute #{attribute}: #{send(attribute).class}"
    end
  end
end

ActiveModel::Model.send :include, ActiveModel::LoggerAttributes
