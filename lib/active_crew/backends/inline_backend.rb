module ActiveCrew
  module Backends
    class InlineBackend
      class Queue
        def size
          0
        end

        def method_missing(method, *args, &block)
          return unless respond_to? method

          super method, *args, &block
        end
      end

      def self.enqueue(*args)
        ActiveCrew::Backends.dequeue *args
      end

      def self.queue(command_name)
        Queue.new
      end
    end
  end
end
