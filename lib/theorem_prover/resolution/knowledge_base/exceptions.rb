require_relative '../knowledge_base'

class KnowledgeBase
  class ContradictionError < StandardError
  end
  class IncompatibleTermsError < StandardError
  end
  class UnificationError < StandardError
  end
end