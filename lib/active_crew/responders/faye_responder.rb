module ActiveCrew
  module Responders
    # FayeResponderError class.
    class FayeResponderError < Exception; end

    # FayeConnectionError class.
    class FayeConnectionError < Exception; end

    # ActiveCrew Faye responder.
    module FayeResponder
      module_function

      MAX_RETRIES = 5

      def init(context, request)
        context[:session] = request.headers['x-session-token']
      end

      # Respond with faye
      def respond(name, invoker, context, model)
        request channel: channel(invoker),
                data: payload(name, invoker, context, model),
                ext: { publish_key: config[:publish_key] }
      end

      def request(message)
        retries = 0

        begin
          validate RestClient.post url, message.to_json, header
        rescue FayeResponderError
          retries += 1
          raise FayeConnectionError $ERROR_INFO unless retries < MAX_RETRIES

          retry
        rescue FayeConnectionError
          Rails.logger.fatal $ERROR_INFO.message
        end
      end

      # @return Invoker channel name
      def channel(invoker)
        "/#{invoker.class.to_s.underscore}/#{invoker.id}"
      end

      # @return Faye request payload
      def payload(name, invoker, context, model)
        {
          invoker: serialize_invoker(invoker),
          session: context[:session],
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

        if model.is_a?(Array) || model.errors.empty?
          resource = ActiveModelSerializers::SerializableResource.new(model, options)
          resource.adapter.respond_to?(:serializable_hash) ? resource.serializable_hash : model
        else
          ActiveModelSerializers::SerializableResource.new(model.errors, options.merge(root: 'errors')).serializable_hash[:errors]
        end
      end

      def status(model)
        model.is_a?(Array) || !model.is_a?(CommandError) && model.valid? ? :success : :failure
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
        "http://#{config[:host]}/faye"
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
