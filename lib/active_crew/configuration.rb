module ActiveCrew
  class Configuration
    attr_accessor :backend, :measurer, :silent

    def initialize
      @backend = :inline
      @silent = false
    end
  end
end
