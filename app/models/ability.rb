class Ability
  include CanCan::Ability

  def initialize(user)
    admin_ids = ENV.fetch('ADMIN_IDS', '').split(',')
    athlete_id = user&.profile&.athlete_id
    if athlete_id && admin_ids.include?(athlete_id.to_s)
      can :manage, :all
    else
      can :read, :all
    end
  end
end
