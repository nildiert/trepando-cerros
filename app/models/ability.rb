class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :read, :all

    if user.admin?
      can :manage, :all
    end

    user.permissions.each do |perm|
      next unless perm.enabled?

      case perm.name
      when 'manage_settings'
        can :manage, :settings
      when 'race_predictor'
        can :use, :race_predictor
      end
    end
  end
end
