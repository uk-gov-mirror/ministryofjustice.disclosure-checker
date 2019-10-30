module ExperimentsHelper
  def adults_enabled?
    cookies[:adults_enabled].present? || current_participant
  end

  def motoring_enabled?
    cookies[:motoring_enabled].present?
  end

  def multiples_enabled?
    cookies[:multiples_enabled].present?
  end
end
