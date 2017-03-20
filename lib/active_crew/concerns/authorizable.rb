module ActiveCrew
  module Authorizable
    extend ActiveSupport::Concern

    def can_execute?
      invoker.can? name, options
    end
  end
end
