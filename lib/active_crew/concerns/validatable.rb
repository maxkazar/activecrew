module ActiveCrew
  module Validatable
    extend ActiveSupport::Concern

    def validate!

    end

    def execute
      validate!

      super
    end
  end
end
