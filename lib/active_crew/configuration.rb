module ActiveCrew
  class Configuration
    attr_accessor :responder, :backend, :measurer, :silent

    def initialize
      @responder = :inline
      @backend = :inline
      @silent = false
    end
  end
end
