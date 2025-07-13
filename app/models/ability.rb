class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :read, :all

    can :manage, :settings if user.persisted?
    can :manage, :all if user.role&.admin?

    role_perms = user.role ? user.role.role_permissions : []
    (role_perms + user.permissions).each do |perm|
      next unless perm.enabled?

      case perm.name
      when 'race_predictor'
        can :use, :race_predictor
      when 'training_plan'
        can :manage, TrainingPlan
      end
    end
  end
end
