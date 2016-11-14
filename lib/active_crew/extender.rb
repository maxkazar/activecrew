module ActiveCrew
  module Extender
    def command(name, options)
      context = { options: options }

      ActiveCrew::Responders.init context, request
      ActiveCrew::Backends.enqueue name, current_user, context
    end
  end
end

ActionController::Base.include ActiveCrew::Extender
