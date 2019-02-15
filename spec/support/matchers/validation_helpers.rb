module ValidationHelpers
  private

  def check_errors(object, attribute, error)
    !object.valid?
    object.errors.added?(attribute, error)
  end

  def errors_for(attribute, object)
    object.errors.details[attribute].map { |h| h[:error] }.compact
  end
end
