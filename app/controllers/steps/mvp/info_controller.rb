module Steps
  module Mvp
    class InfoController < Steps::MvpStepController
      before_action :validate_reference
      before_action :increment_access_count, only: [:edit]

      def edit
        @form_object = InfoForm.build(participant_record)
      end

      def update
        update_and_advance(
          InfoForm, as: :info,
          record: participant_record
        )
      end

      private

      def reference
        params[:id]
      end

      # TODO: whitelist / validate reference (params[:id])
      def validate_reference
        reference.present? || (raise 'Participant reference not found')
      end

      # Using `+= 1` instead of `#increment` so the `updated_at` column
      # gets also updated as part of the record save.
      def increment_access_count
        participant_record.access_count += 1
        participant_record.save
      end

      def participant_record
        @_participant_record ||= Participant.find_or_create_by(
          reference: reference
        )
      end
    end
  end
end
