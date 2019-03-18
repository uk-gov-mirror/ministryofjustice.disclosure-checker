module GovukComponents
  module ErrorHelpers
    # rubocop:disable Metrics/BlockLength
    GovukElementsErrorsHelper.module_eval do
      def self.error_summary(object, heading)
        return unless errors_exist? object

        error_summary_div do
          error_summary_heading(heading) + error_summary_list(object)
        end
      end

      def self.error_summary_div(&block)
        attrs = {
          class: 'govuk-error-summary',
          aria: { labelledby: 'error-summary-title' },
          data: { module: 'error-summary' },
          role: 'alert',
          tabindex: '-1',
        }.freeze

        content_tag(:div, attrs) do
          yield block
        end
      end

      def self.error_summary_heading(text)
        content_tag :h2, text,
                    id: 'error-summary-title',
                    class: 'govuk-error-summary__title'
      end

      def self.error_summary_list(object)
        content_tag(:div, class: 'govuk-error-summary__body') do
          content_tag(:ul, class: 'govuk-list govuk-error-summary__list') do
            child_to_parents = child_to_parent(object)
            messages = error_summary_messages(object, child_to_parents)

            # :nocov:
            # TODO: This will be removed once we have got child parent relationship
            messages << children_with_errors(object).map do |child|
              error_summary_messages(child, child_to_parents)
            end
            # :nocov:

            messages.flatten.join('').html_safe
          end
        end
      end

      def self.link_to_error(object_prefixes, attribute)
        [*object_prefixes, attribute, 'error'].join('_').prepend('#')
      end
    end
    # rubocop:enable Metrics/BlockLength
  end
end
