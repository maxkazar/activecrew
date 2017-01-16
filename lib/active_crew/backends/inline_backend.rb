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

      class << self
        def enqueue(*args)
          ActiveCrew::Backends.dequeue *args
        end

        def queue(command_name)
          Queue.new
        end

        def context
          {}
        end
      end
    end
  end
end
