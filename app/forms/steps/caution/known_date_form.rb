module Steps
  module Caution
    class KnownDateForm < BaseForm
      attribute :known_date, MultiParamDate
      attribute :approximate_known_date, Boolean

      validates_presence_of :known_date
      validates :known_date, sensible_date: true

      private

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check

        disclosure_check.update(
          known_date: known_date,
          approximate_known_date: approximate_known_date
        )
      end
    end
  end
end
