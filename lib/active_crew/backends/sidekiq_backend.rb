module ActiveCrew
  module Backends
    class SidekiqBackend
      include Sidekiq::Worker

      class << self
        def enqueue(*args)
          Sidekiq::Client.push 'class' => self,
                               'queue' => queue_name(args.first),
                               'args' => args
        end

        def queue_name(command_name)
          command_name[/^(.*)\/[^\/]*$/, 1].underscore.gsub(/\//, '_')
        end

        def queue(command_name)
          Sidekiq::Queue.new queue_name command_name
        end
      end

      def perform(*args)
        ActiveCrew::Backends.dequeue *args
      end
    end
  end
end
