module ActiveModel
  module LoggerAttributes
    class Device < ::Logger::LogDevice
      def initialize(attribute, model)
        @attribute = attribute
        @model = model
      end

      def write(message)
        @model.send(@attribute) << message.strip
      end

      def close
        # noop
      end
    end
  end
end
