module ActiveCrew
  module Validatable
    extend ActiveSupport::Concern

    def validate
      true
    end

    def execute
      return unless validate

      super
    end
  end
end
