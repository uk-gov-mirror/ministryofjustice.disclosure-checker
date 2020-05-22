module Calculators
  module Motoring
    module Youth
      # If an endorsement was received
      # start_date + 2.5 years
      # If an endorsement was not received
      # start_date + 6 months
      class Fine < MotoringCalculator
        REHABILITATION_1 = { months: 30 }.freeze
        REHABILITATION_2 = { months: 6 }.freeze

        def expiry_date
          return conviction_start_date.advance(REHABILITATION_1) if motoring_endorsement?

          conviction_start_date.advance(REHABILITATION_2)
        end
      end
    end
  end
end
