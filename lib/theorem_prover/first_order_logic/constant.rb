require_relative 'function'

module FirstOrderLogic
  class Constant < Function
    def initialize(name)
      super(name, [])
    end

    def accept(visitor)
      visitor.visit_constant self
    end

    def to_s
      name
    end

    protected

    def state
      [@name]
    end
  end
end