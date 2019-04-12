class Motoring < ValueObject
  VALUES = [
    DISQUALIFICATION = new(:disqualification),
    ENDORSEMENT = new(:endorsement),
    PENALTY_POINTS = new(:penalty_points)
  ].freeze

  def self.values
    VALUES
  end
end
