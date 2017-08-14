module ActiveCrew
  module Lockable
    def execute
      super unless locked?
    end

    def locked?
      options = context[:locker]
      return false if options.blank?

      model = deserialize_locker
      return true if model.blank?

      model.locker != options[:value]
    end

    def lock(model)
      return unless model

      locker_was = context[:locker]
      context[:locker] = serialize_locker model

      yield

      context[:locker] = locker_was
    end

    protected

    def serialize_locker(model)
      { class: model.class.to_s,
        id: model.id.to_s,
        value: model.lock }
    end

    def deserialize_locker
      locker = context[:locker]
      locker[:class].safe_constantize&.find locker[:id]
    end
  end
end
