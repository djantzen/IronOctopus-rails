class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.is_admin?
      can :manage, :all
      can :read, User
      can :read, Feedback
    else
      #can :read, :all

      # routines
      can :update, Routine, :trainer_id => user.id
      can :perform, Routine, :client_id => user.id
      can :create, Routine do |routine, client|
        client.trainers.include?(user) || user == client
      end

      # programs
      can :update, Program, :trainer_id => user.id
      can :create, Program do |program, client|
        client.trainers.include?(user) || user == client
      end

      # activities
      #can :read, Activity, :creator => user.id
      #can :read, Activity, :visible_to_all => true
      can :update, Activity, :creator_id => user.id

      # implements
      can :create, Implement if user.is_admin?
      can :update, Implement if user.is_admin?

      # body part
      can :create, BodyPart if user.is_admin?
      can :update, BodyPart if user.is_admin?
    end

    # Define abilities for the passed in user here. For example:
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
