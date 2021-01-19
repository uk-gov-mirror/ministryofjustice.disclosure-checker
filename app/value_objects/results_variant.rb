class ResultsVariant < ValueObject
  VALUES = [
    SPENT        = new(:spent),
    NOT_SPENT    = new(:not_spent),
    NEVER_SPENT  = new(:never_spent),
    SPENT_SIMPLE = new(:spent_simple),
    INDEFINITE   = new(:indefinite),
  ].freeze

  def self.values
    VALUES
  end
end
