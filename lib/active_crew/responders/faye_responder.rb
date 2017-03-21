module ActiveCrew
  module Responders
    # ActiveCrew Faye responder.
    module FayeResponder

      # FayeResponderError class.
      class FayeResponderError < Exception; end

      module_function

      MAX_RETRIES = 5

      # Respond with faye
      # Respond with faye
      def respond(name, invoker, options, model)
        request channel: channel(invoker, options),
                data: payload(name, invoker, options, model),
                ext: { publish_key: config[:publish_key] }
      end

      def request(message)
        retries = 0

        begin
          validate RestClient.post url, message.to_json, header
        rescue FayeResponderError
          retries += 1

          retry if retries < MAX_RETRIES

          Rails.logger.fatal "[#{self}] #{$ERROR_INFO.message}"
        end
      end

      # @return Invoker channel name
      def channel(invoker, options)
        options[:channel] || "/#{invoker.class.to_s.underscore}/#{invoker.id}"
      end

      # @return Faye request payload
      def payload(name, invoker, options, model)
        {
          invoker: serialize_invoker(invoker),
          session: options[:session],
          command: name,
          status: status(model),
          response: serialize(model)
        }
      end

      def serialize_invoker(invoker)
        serialize invoker, serializer: "#{invoker.class}::InvokerSerializer".constantize
      end

      # Serialize payload
      def serialize(model, options = {})
        return { base: model.message } if model.is_a? CommandError

        if model.is_a?(Array) || !model.respond_to?(:errors) || model.errors.empty?
          resource = ActiveModelSerializers::SerializableResource.new(model, options)
          resource.adapter.respond_to?(:serializable_hash) ? resource.serializable_hash : model
        else
          ActiveModelSerializers::SerializableResource.new(model.errors, root: 'errors').serializable_hash[:errors]
        end
      end

      def status(model)
        !model.is_a?(CommandError) && (!model.respond_to?(:errors) || model.errors.empty?) ? :success : :failure
      end

      # @return Faye request header
      def header
        {
          'Content-Type' => 'application/json',
          'Pragma' => 'no-cache',
          'X-Requested-With' => 'XMLHttpRequest'
        }
      end

      # Validate faye response
      def validate(response)
        fail FayeResponderError, response.code unless response.code == 200

        response = JSON.parse(response)[0].symbolize_keys
        fail FayeResponderError, response[:error] unless response[:successful]
      end

      def url
        "#{config[:ssl] ? 'https' : 'http'}://#{config[:host]}/faye"
      end

      def config
        return @config if defined? @config

        @config = YAML.load(ERB.new(File.new(config_path).read).result)[Rails.env]
        @config = (@config || {}).symbolize_keys
      end

      def config_path
        File.join(Rails.root, 'config', 'faye.yml')
      end
    end
  end
end
