module Calculators
  module Motoring
    module Adult
      # An endorsement is always received when Penalty Points
      # start_date + 5 years
      class PenaltyPoints < MotoringCalculator
        REHABILITATION_1 = { months: 60 }.freeze

        def expiry_date
          conviction_start_date.advance(REHABILITATION_1)
        end
      end
    end
  end
end
