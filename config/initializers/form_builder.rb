# PLEASE BE AWARE:
#
# We are still using the gem `govuk_elements_form_builder` that produces a markup
# not compatible with the new Design System, as there is no ready to use alternative.
#
# To workaround these limitations, we've created our own `FormBuilder` class, which
# inherits from the old `GovukElementsFormBuilder::FormBuilder` class, to reuse as
# much as possible from the old gem (mainly locales and error handling, and some other
# utility methods) but overrides some other methods to produce new markup/styles.
#
# This is an interim solution and one that serves well for our own requirements in
# this new service, as we require a very limited set of components (mainly radios and
# dates). This will speed up the time needed to migrate components to the new design
# system and also will allow us to continue using the very same interface we've been
# using in previous projects.
#
# Going forwards, and once we have enough components migrated and the code cleaned up
# and refactored, we can consider extracting it to a gem for reuse in other projects.
#
require_relative '../../lib/govuk_components/form_builder'

ActionView::Base.default_form_builder = GovukComponents::FormBuilder
