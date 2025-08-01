class Ability
  include CanCan::Ability

  PERMISSIONS = RolePermission::AVAILABLE_PERMISSIONS

  def initialize(user)
    user ||= User.new

    can :read, :all

    can :manage, :settings if user.persisted?
    if user.role&.admin?
      can :manage, :all
      can :use, :race_predictor
    end
    can :manage, :athletes if user.role&.name == 'trainer'

    role_perms = user.role ? user.role.role_permissions : []
    (role_perms + user.permissions).each do |perm|
      next unless perm.enabled?

      case perm.name
      when 'race_predictor'
        can :use, :race_predictor
      when 'training_plan'
        can :manage, TrainingPlan
      when 'club'
        can :manage, Club
      when 'athletes'
        can :manage, :athletes
      when 'users'
        can :manage, User
      end
    end
  end
end
