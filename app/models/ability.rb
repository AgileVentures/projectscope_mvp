class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
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

    user ||= User.new # guest user (not logged in)
    can :write_log, Project
    if user.is_admin? or user.is_instructor?
      can :manage, :all
    else
      can [:init_new, :init_update], User
      can [:show_metric, :get_metric_data, :get_metric_series], Project
      can :read, Project
      unless user.project.nil?
        can :manage, Project, :id => user.project.id
        can [:read, :update], Comment, :metric_sample => { :project_id => user.project.id }
      end
    end
  end
end
