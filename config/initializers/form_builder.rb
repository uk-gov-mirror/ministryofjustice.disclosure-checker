ActionView::Base.default_form_builder = GovukElementsFormBuilder::FormBuilder

ActionView::Base.default_form_builder.class_eval do
  include CustomFormHelpers
end
