class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :read, :all

    can :manage, :settings if user.persisted?
    can :manage, :all if user.admin?

    user.permissions.each do |perm|
      next unless perm.enabled?

      case perm.name
      when 'race_predictor'
        can :use, :race_predictor
      end
    end
  end
end
