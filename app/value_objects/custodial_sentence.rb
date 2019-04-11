class CustodialSentence < ValueObject
  VALUES = [
    DETENTION_AND_TRAINING_ORDER = new(:detention_and_training_order),
    PRISION_SENTENCE = new(:prision_sentence),
    SUSPENDED_PRISION_SENTENCE = new(:suspended_prision_sentence)
  ].freeze

  def self.values
    VALUES
  end
end
