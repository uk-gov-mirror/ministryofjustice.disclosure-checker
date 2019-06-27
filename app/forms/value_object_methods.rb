module ValueObjectMethods
  def self.included(base)
    base.send :include, InstanceMethods
  end

  module InstanceMethods
    def conviction_type
      ConvictionType.find_constant(disclosure_check.conviction_type)
    end

    def conviction_subtype
      ConvictionType.find_constant(disclosure_check.conviction_subtype)
    end
  end
end
