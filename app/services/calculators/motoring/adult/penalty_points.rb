module Calculators
  module Motoring
    module Adult
      # If an endorsement was received:
      # start_date + 5 years
      # If an endorsement was not received:
      # start_date + 3 years
      class PenaltyPoints < MotoringCalculator
        REHABILITATION_1 = { months: 60 }.freeze
        REHABILITATION_2 = { months: 36 }.freeze

        def expiry_date
          return conviction_start_date.advance(REHABILITATION_1) if motoring_endorsement?

          conviction_start_date.advance(REHABILITATION_2)
        end
      end
    end
  end
end
