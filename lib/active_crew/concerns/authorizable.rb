module ActiveCrew
  class AuthorizationError < Exception; end

  module Authorizable
    extend ActiveSupport::Concern

    def execute
      raise AuthorizationError unless can_execute?

      super
    end

    def can_execute?
      invoker.can? name, options
    end
  end
end
