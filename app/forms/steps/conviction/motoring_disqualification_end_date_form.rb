module Steps
  module Conviction
    class MotoringDisqualificationEndDateForm < BaseForm
      attribute :motoring_disqualification_end_date, MultiParamDate
      attribute :approximate_motoring_disqualification_end_date, Boolean

      validates :motoring_disqualification_end_date, sensible_date: { allow_future: true }

      private

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check

        disclosure_check.update(
          motoring_disqualification_end_date: motoring_disqualification_end_date,
          approximate_motoring_disqualification_end_date: approximate_motoring_disqualification_end_date
        )
      end
    end
  end
end
