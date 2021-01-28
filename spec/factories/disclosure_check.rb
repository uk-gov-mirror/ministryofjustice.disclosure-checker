# Important: factories should always produce predictable data, specially dates.
# This will avoid headaches with flaky tests.
#
FactoryBot.define do
  factory :disclosure_check do
    check_group
    kind { CheckKind::CAUTION }
    known_date { Date.new(2018, 10, 31) }
    under_age { GenericYesNo::YES }
    caution_type { CautionType::YOUTH_SIMPLE_CAUTION }

    trait :youth do
      under_age { GenericYesNo::YES }
    end

    trait :adult do
      under_age { GenericYesNo::NO }
    end

    trait :caution

    trait :conviction do
      kind { CheckKind::CONVICTION }
      known_date { nil }
      caution_type { nil }
    end

    trait :with_known_date do
      known_date { Date.new(2018, 10, 31) }
    end

    trait :conviction_with_known_date do
      conviction
      with_known_date
    end

    trait :dto_conviction do
      kind { CheckKind::CONVICTION }
      conviction_type { ConvictionType::CUSTODIAL_SENTENCE }
      conviction_subtype { ConvictionType::DETENTION_TRAINING_ORDER }
      conviction_length { 9 }
      conviction_length_type { ConvictionLengthType::WEEKS }
    end

    trait :compensation do
      kind { CheckKind::CONVICTION }
      conviction_type { ConvictionType::FINANCIAL }
      conviction_subtype { ConvictionType::COMPENSATION_TO_A_VICTIM }
      compensation_payment_date { Date.new(2019, 10, 31) }
    end

    trait :youth_simple_caution do
      caution_type { CautionType::YOUTH_SIMPLE_CAUTION }
    end

    trait :youth_conditional_caution do
      caution_type { CautionType::YOUTH_CONDITIONAL_CAUTION }
      conditional_end_date { Date.new(2018, 12, 25) }
    end

    trait :suspended_prison_sentence do
      under_age { GenericYesNo::NO }
      kind { CheckKind::CONVICTION }
      conviction_type { ConvictionType::ADULT_CUSTODIAL_SENTENCE }
      conviction_subtype { ConvictionType::ADULT_SUSPENDED_PRISON_SENTENCE }
      conviction_length_type { ConvictionLengthType::MONTHS }
      conviction_length { 15 }
    end

    # Prison

    trait :with_conviction_bail do
      conviction_bail { GenericYesNo::YES }
      conviction_bail_days { 10 }
    end

    trait :with_prison_sentence do
      adult
      conviction_with_known_date
      conviction_type { ConvictionType::ADULT_CUSTODIAL_SENTENCE }
      conviction_subtype { ConvictionType::ADULT_PRISON_SENTENCE }
      conviction_length_type { ConvictionLengthType::MONTHS }
      conviction_length { 12 }
    end

    # Financial

    trait :with_fine do
      conviction_with_known_date
      conviction_type { self.under_age.inquiry.yes? ? ConvictionType::FINANCIAL : ConvictionType::ADULT_FINANCIAL }
      conviction_subtype { self.under_age.inquiry.yes? ? ConvictionType::FINE : ConvictionType::ADULT_FINE }
    end

    # Motoring

    trait :with_motoring_disqualification do
      conviction_with_known_date
      conviction_type { self.under_age.inquiry.yes? ? ConvictionType::YOUTH_MOTORING : ConvictionType::ADULT_MOTORING }
      conviction_subtype { self.under_age.inquiry.yes? ? ConvictionType::YOUTH_DISQUALIFICATION : ConvictionType::ADULT_DISQUALIFICATION }
      conviction_length { 6 }
      conviction_length_type { ConvictionLengthType::MONTHS }
      motoring_endorsement { GenericYesNo::NO }
    end

    trait :with_motoring_penalty_points do
      conviction_with_known_date
      conviction_type { self.under_age.inquiry.yes? ? ConvictionType::YOUTH_MOTORING : ConvictionType::ADULT_MOTORING }
      conviction_subtype { self.under_age.inquiry.yes? ? ConvictionType::YOUTH_PENALTY_POINTS : ConvictionType::ADULT_PENALTY_POINTS }
    end

    trait :with_motoring_fine do
      conviction_with_known_date
      conviction_type { self.under_age.inquiry.yes? ? ConvictionType::YOUTH_MOTORING : ConvictionType::ADULT_MOTORING }
      conviction_subtype { self.under_age.inquiry.yes? ? ConvictionType::YOUTH_MOTORING_FINE : ConvictionType::ADULT_MOTORING_FINE }
    end

    # Discharge

    trait :with_bind_over do
      conviction_with_known_date
      conviction_type { self.under_age.inquiry.yes? ? ConvictionType::DISCHARGE : ConvictionType::ADULT_DISCHARGE }
      conviction_subtype { self.under_age.inquiry.yes? ? ConvictionType::BIND_OVER : ConvictionType::ADULT_BIND_OVER }
    end

    trait :with_discharge_order do
      conviction_with_known_date
      conviction_type { self.under_age.inquiry.yes? ? ConvictionType::DISCHARGE : ConvictionType::ADULT_DISCHARGE }
      conviction_subtype { self.under_age.inquiry.yes? ? ConvictionType::CONDITIONAL_DISCHARGE : ConvictionType::ADULT_CONDITIONAL_DISCHARGE }
      conviction_length { 12 }
      conviction_length_type { ConvictionLengthType::MONTHS }
    end

    # Community Reparation
    # Only for adults

    trait :with_community_order do
      conviction_with_known_date
      conviction_type { ConvictionType::ADULT_COMMUNITY_REPARATION }
      conviction_subtype { ConvictionType::ADULT_COMMUNITY_ORDER }
    end

    trait :with_sexual_harm_order do
      conviction_with_known_date
      conviction_type { ConvictionType::ADULT_COMMUNITY_REPARATION }
      conviction_subtype { ConvictionType::ADULT_SEXUAL_HARM_PREVENTION_ORDER }
    end

    trait :completed do
      status { :completed }
    end
  end
end
