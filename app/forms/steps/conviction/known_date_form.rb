module Steps
  module Conviction
    class KnownDateForm < BaseForm
      include GovUkDateFields::ActsAsGovUkDate

      attribute :known_date, Date

      acts_as_gov_uk_date :known_date

      validates_presence_of :known_date

      private

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check

        disclosure_check.update(
          known_date: known_date
        )
      end
    end
  end
end
