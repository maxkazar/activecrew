class Invoker
  def self.find(id)
    @invoker ||= Invoker.new
  end

  def id
    1
  end

  def can?(name, options)
    true
  end
end
