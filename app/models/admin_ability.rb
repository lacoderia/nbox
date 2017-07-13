class AdminAbility
  include CanCan::Ability

  def initialize(admin_user)
    
    if admin_user.role? :super_admin
      can :manage, :all
      cannot :read, ScheduleForInstructor
    elsif admin_user.role? :instructor or admin_user.role? :dj
      can :read, ActiveAdmin::Page, :name => "Dashboard"
      can :manage, ScheduleForInstructor
    elsif admin_user.role? :front_desk
      can :read, ActiveAdmin::Page, :name => "Dashboard"
      can :manage, Appointment
    elsif admin_user.role? :niumedia
      can :read, ActiveAdmin::Page, :name => "Dashboard"
      can :manage, Instructor
    end
 
  end
  
end
