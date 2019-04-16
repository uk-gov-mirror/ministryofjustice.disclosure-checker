module Steps
  module Conviction
    class ConvictionEndDateForm < BaseForm
      include GovUkDateFields::ActsAsGovUkDate

      attribute :conviction_end_date, Date

      acts_as_gov_uk_date :conviction_end_date

      validates_presence_of :conviction_end_date

      private

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check

        disclosure_check.update(
          conviction_end_date: conviction_end_date
        )
      end
    end
  end
end
