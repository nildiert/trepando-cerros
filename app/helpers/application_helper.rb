module ApplicationHelper
  WORKOUT_COLOR_CLASSES = {
    'rest' => 'bg-green-700 text-white',
    'easy_run' => 'bg-blue-500 text-white',
    'long_run' => 'bg-blue-800 text-white',
    'intensity' => 'bg-red-700 text-white',
    'strength' => 'bg-orange-500 text-white'
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
