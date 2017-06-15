module ActiveCrew
  module Extender
    def command_context
      @command_context ||= {}
    end

    def command(name, options = {})
      context = { options: options, session: request.headers['x-session-token'] }.merge(context: command_context)

      ActiveCrew::Backends.enqueue name, current_user, context
    end
  end
end

ActionController::Base.include ActiveCrew::Extender
