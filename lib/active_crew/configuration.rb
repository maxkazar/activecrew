module ActiveCrew
  class Configuration
    attr_accessor :responder, :backend, :measurer

    def initialize
      @responder = :inline
      @backend = :inline
    end
  end
end
