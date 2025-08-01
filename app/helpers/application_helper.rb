module ApplicationHelper
  MONTHS_ES_ABBR = %w[Ene Feb Mar Abr May Jun Jul Ago Sep Oct Nov Dic].freeze
  WORKOUT_COLOR_CLASSES = {
    'rest' => 'bg-[#A3BE8C] hover:bg-[#8CA877] text-white',
    'easy_run' => 'bg-[#8FBCBB] hover:bg-[#7aa9a8] text-white',
    'long_run' => 'bg-[#5E81AC] hover:bg-[#4c6b90] text-white',
    'intensity' => 'bg-[#BF616A] hover:bg-[#a04c54] text-white',
    'strength' => 'bg-[#D08770] hover:bg-[#b36f5d] text-white'
  }.freeze

  WORKOUT_BORDER_CLASSES = {
    'rest' => 'border-[#A3BE8C]',
    'easy_run' => 'border-[#8FBCBB]',
    'long_run' => 'border-[#5E81AC]',
    'intensity' => 'border-[#BF616A]',
    'strength' => 'border-[#D08770]'
  }.freeze

  def workout_color_class(type)
    WORKOUT_COLOR_CLASSES[type.to_s] || ''
  end

  def workout_border_class(type)
    WORKOUT_BORDER_CLASSES[type.to_s] || ''
  end

  def workout_badge(type)
    content_tag(
      :span,
      t("activerecord.attributes.training_plan_day.workout_types.#{type}"),
      class: "badge #{workout_color_class(type)}"
    )
  end

  def short_date_es(date)
    return "" unless date

    "#{date.day} #{MONTHS_ES_ABBR[date.month - 1]}"
  end
end
