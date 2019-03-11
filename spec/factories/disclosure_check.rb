FactoryBot.define do
  factory :disclosure_check do
    kind { CheckKind::CAUTION }
    caution_date { Faker::Date.backward(14).strftime('%Y-%m-%d') }
    under_age { 'no' }
    caution_type { CautionType::SIMPLE_CAUTION }

    trait :conviction do
      kind { CheckKind::CONVICTION }
      caution_date { nil }
      under_age { nil }
      caution_type { nil }
    end

    trait :conditional_caution do
      caution_type { CautionType::CONDITIONAL_CAUTION }
    end

    trait :youth_simple_caution do
      under_age { 'no' }
      caution_type { CautionType::YOUTH_SIMPLE_CAUTION }
    end

    trait :youth_conditional_caution do
      under_age { 'no' }
      caution_type { CautionType::YOUTH_CONDITIONAL_CAUTION }
    end
  end
end
