module ApplicationHelper
  WORKOUT_COLOR_CLASSES = {
    'rest' => 'bg-green-300 text-green-800',
    'easy_run' => 'bg-blue-200 text-blue-800',
    'long_run' => 'bg-blue-700 text-white',
    'intensity' => 'bg-orange-200 text-orange-800',
    'strength' => 'bg-orange-200 text-orange-800'
  }.freeze

  def workout_color_class(type)
    WORKOUT_COLOR_CLASSES[type.to_s] || ''
  end

  def workout_badge(type)
    content_tag(
      :span,
      t("activerecord.attributes.training_plan_day.workout_types.#{type}"),
      class: "badge #{workout_color_class(type)}"
    )
  end
end
