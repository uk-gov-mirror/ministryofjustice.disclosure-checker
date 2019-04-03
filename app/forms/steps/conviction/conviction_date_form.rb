module Steps
  module Conviction
    class ConvictionDateForm < BaseForm
      include GovUkDateFields::ActsAsGovUkDate

      attribute :conviction_date, Date

      acts_as_gov_uk_date :conviction_date

      validates_presence_of :conviction_date

      private

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check

        disclosure_check.update(
          conviction_date: conviction_date
        )
      end
    end
  end
end
