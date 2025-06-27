class Ability
  include CanCan::Ability

  def initialize(athlete_id)
    admin_ids = ENV.fetch('ADMIN_IDS', '').split(',')
    if admin_ids.include?(athlete_id.to_s)
      can :manage, :all
    else
      can :read, :all
    end
  end
end
