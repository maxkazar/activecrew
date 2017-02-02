module ActiveCrew
  module Extender
    def command(name, options)
      context = { options: options, session: request.headers['x-session-token'] }

      ActiveCrew::Backends.enqueue name, current_user, context
    end
  end
end

ActionController::Base.include ActiveCrew::Extender
