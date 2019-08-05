module BypassUnderAge
  private

  def as_name
    cookies[:adults_enabled].present? ? :bypass_under_age : :under_age
  end
end
