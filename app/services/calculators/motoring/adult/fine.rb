module Calculators
  module Motoring
    module Adult
      # If an endorsement was received
      # start_date + 5 years
      # If an endorsement was not received
      # start_date + 1 year
      class Fine < BaseCalculator
        REHABILITATION_1 = { months: 60 }.freeze
        REHABILITATION_2 = { months: 12 }.freeze

        def expiry_date
          return conviction_start_date.advance(REHABILITATION_1) if motoring_endorsement?

          conviction_start_date.advance(REHABILITATION_2)
        end
      end
    end
  end
end
