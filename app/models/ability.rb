class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.is_admin?
      can :manage, :all

      can :read, User
      can :read, Feedback

      # implements
      can :read, Implement
      can :create, Implement
      can :update, Implement

      # body part
      can :read, BodyPart
      can :create, BodyPart
      can :update, BodyPart
    else

      # users
      can :read, User do |client|
        client.trainers.include?(user) || user == client
      end
      can :update, User, :user_id => user.id

      # routines
      can :read, Routine, :trainer_id => user.id
      can :read, Routine, :client_id => user.id
      can :update, Routine, :trainer_id => user.id
      can :perform, Routine, :client_id => user.id
      can :create, Routine do |routine, client|
        client.trainers.include?(user) || user == client
      end

      # programs
      can :read, Program, :trainer_id => user.id
      can :read, Program, :client_id => user.id
      can :update, Program, :trainer_id => user.id
      can :create, Program do |program, client|
        client.trainers.include?(user) || user == client
      end

      # activities
      #can :read, Activity, :creator => user.id
      #can :read, Activity, :visible_to_all => true
      can :update, Activity, :creator_id => user.id

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
