module ApplicationHelper
  WORKOUT_COLOR_CLASSES = {
    'rest' => 'bg-green-700 hover:bg-green-800 text-white',
    'easy_run' => 'bg-blue-500 hover:bg-blue-600 text-white',
    'long_run' => 'bg-blue-800 hover:bg-blue-900 text-white',
    'intensity' => 'bg-red-700 hover:bg-red-800 text-white',
    'strength' => 'bg-orange-500 hover:bg-orange-600 text-white'
  }.freeze

  WORKOUT_BORDER_CLASSES = {
    'rest' => 'border-green-700',
    'easy_run' => 'border-blue-500',
    'long_run' => 'border-blue-800',
    'intensity' => 'border-red-700',
    'strength' => 'border-orange-500'
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
end
