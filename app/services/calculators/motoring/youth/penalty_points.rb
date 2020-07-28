module Calculators
  module Motoring
    module Youth
      # An endorsement is always received when Penalty Points
      # start_date + 3 years
      # Because the Youth endorsement is 2.5 years and penalty points are 3 years,
      # even if there is an endorsement, the penalty points have a longer duration
      # hence being 3 years always
      class PenaltyPoints < MotoringCalculator
        REHABILITATION_1 = { months: 36 }.freeze

        def expiry_date
          conviction_start_date.advance(REHABILITATION_1)
        end
      end
    end
  end
end
