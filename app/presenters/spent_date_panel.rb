class SpentDatePanel
  attr_reader :spent_date, :kind

  def initialize(spent_date:, kind:)
    @spent_date = spent_date
    @kind = kind
  end

  def to_partial_path
    'results/shared/spent_date_panel'
  end

  def scope
    [to_partial_path, tense]
  end

  def date
    I18n.l(spent_date) if spent_date.instance_of?(Date)
  end

  private

  # TODO: we use this or similar method in other places. Unify them.
  def tense
    if spent_date.instance_of?(Date)
      spent_date.past? ? ResultsVariant::SPENT : ResultsVariant::NOT_SPENT
    else
      spent_date
    end
  end
end
