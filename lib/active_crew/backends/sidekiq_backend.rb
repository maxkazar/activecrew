module ActiveCrew
  module Backends
    class SidekiqBackend
      include Sidekiq::Worker

      class << self
        def enqueue(name, invoker, context)
          Sidekiq::Client.push 'class' => self,
                               'queue' => queue_name(name),
                               'args' => [YAML.dump([name, invoker, normalize(context)])]
        end

        def queue_name(command_name)
          command_name[/^(.*)\/[^\/]*$/, 1].underscore.gsub(/\//, '_')
        end

        def queue(command_name)
          Sidekiq::Queue.new queue_name command_name
        end

        def context
          tid = Thread.current["sidekiq_tid"] ||= (Thread.current.object_id ^ ::Process.pid).to_s(36)
          Sidekiq::Processor::WORK_STATE.dup[tid]
        end

        private

        def normalize(context)
          context.merge(options: context.fetch(:options, {}).to_hash).to_hash
        end
      end

      def perform(context)
        ActiveCrew::Backends.dequeue *YAML.unsafe_load(context)
      end
    end
  end
end
