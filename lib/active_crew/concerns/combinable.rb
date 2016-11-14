module ActiveCrew
  # Combinable behavior helps to combine command executions into one command execution
  module Combinable
    def execute
      super
      execute_combine_commands
    end

    def combine_command(name, options = {})
      combine_command_options = combine_commands[name] ||= {}
      options.each do |key, value|
        combine_command_value = combine_command_options[key] ||= []
        combine_command_value << value unless combine_command_value.include? value
      end
    end

    def combine_commands
      @combine_commands ||= {}
    end

    private

    def execute_combine_commands
      combine_commands.each { |name, options| command name, options }
    end
  end
end
