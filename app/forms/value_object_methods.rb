module ValueObjectMethods
  APPROXIMATE_DATE_ATTRS = [
    :approximate_known_date,
    :approximate_conviction_date,
    :approximate_conditional_end_date,
    :approximate_compensation_payment_date,
  ].freeze

  def self.included(base)
    base.send :include, InstanceMethods
  end

  module InstanceMethods
    def caution_type
      CautionType.find_constant(disclosure_check.caution_type)
    end

    def conviction_type
      ConvictionType.find_constant(disclosure_check.conviction_type)
    end

    def conviction_subtype
      ConvictionType.find_constant(disclosure_check.conviction_subtype)
    end

    def caution?
      disclosure_check.kind.inquiry.caution?
    end

    def conviction?
      disclosure_check.kind.inquiry.conviction?
    end

    def offence_type
      return caution_type if caution?
      return conviction_subtype if conviction?

      raise 'Unknown or nil check kind'
    end

    def approximate_dates?
      APPROXIMATE_DATE_ATTRS.any? { |attr| disclosure_check.try(attr) }
    end
  end
end
