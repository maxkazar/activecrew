module ActiveCrew
  module Responders
    autoload :InlineResponder, 'active_crew/responders/inline_responder'
    autoload :FayeResponder, 'active_crew/responders/faye_responder'

    class << self
      attr_reader :default

      def create
        @default = "ActiveCrew::Responders::#{responder.to_s.classify}Responder".constantize
      rescue NameError
        raise ArgumentError, "Unsupported responder #{responder} for active command."
      end

      def init(context, request)
        default.init(context, request) if default.respond_to? :init 
      end

      def respond_with(name, invoker, context, model)
        default.respond name, invoker, context, model
      end

      private

      def responder
        ActiveCrew.configuration.responder
      end
    end
  end
end
