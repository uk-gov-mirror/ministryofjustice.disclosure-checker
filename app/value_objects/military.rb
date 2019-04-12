class Military < ValueObject
  VALUES = [
    MILITARY_DISPOSAL = new(:military_disposal),
    REMOVAL_FROM_HMS = new(:removal_from_hms),
    SERVICE_DETENTION = new(:service_detention)
  ].freeze

  def self.values
    VALUES
  end
end
