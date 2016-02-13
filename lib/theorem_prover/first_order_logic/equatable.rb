module Equatable
  def ==(o)
    o.class == self.class && o.state == state
  end

  alias_method :eql?, :==

  def hash
    state.hash
  end
end