require 'rubygems'

require 'active_support/all'
require 'active_crew/version'
require 'active_crew/configuration'
require 'active_crew/concerns/authorizable'
require 'active_crew/concerns/chainable'
require 'active_crew/concerns/commandable'
require 'active_crew/concerns/combinable'
require 'active_crew/concerns/lockable'
require 'active_crew/concerns/respondable'
require 'active_crew/concerns/measurable'
require 'active_crew/concerns/validatable'
require 'active_crew/base'
require 'active_crew/backends'
require 'active_crew/responders'

require 'active_crew/extender' if defined? ActionController

module ActiveCrew
  class << self
    # Getter for shared global objects
    attr_reader :configuration

    # Returns the global [Configuration](ActiveCrew/Configuration) object.
    #
    # @example
    #     ActiveCrew.configuration.responder = :pusher
    def configuration
      @configuration ||= ActiveCrew::Configuration.new
    end

    # Yields the global configuration to a block.
    # @yield [Configuration] global configuration
    #
    # @example
    #     ActiveCrew.configure do |config|
    #       config.responder = :fayer
    #     end
    def configure
      yield configuration if block_given?

      Backends.create
      Responders.create
    end
  end
end
