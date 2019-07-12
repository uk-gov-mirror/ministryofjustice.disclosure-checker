module ResultHelper
  def title_string(object, kind)
    return t('title.no_date_html', scope: "results/#{kind}") unless object.instance_of?(Date)

    tense = past_or_present(object)
    t("title.#{tense}_html", scope: "results/#{kind}", date: I18n.l(object))
  end

  def statement_string(object, kind)
    return t('statement.no_date_html', scope: "results/#{kind}") unless object.instance_of?(Date)

    tense = past_or_present(object)
    t("statement.#{tense}_html", scope: "results/#{kind}")
  end

  private

  def past_or_present(date)
    date.past? ? 'past' : 'present'
  end
end
