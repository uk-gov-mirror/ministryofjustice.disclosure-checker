module ExperimentsHelper
  def multiples_enabled?
    cookies[:multiples_enabled].present?
  end
end
