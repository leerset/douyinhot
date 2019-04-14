# Define the abilites of each user role.
class Ability
  include CanCan::Ability

  # Initialize abilities.
  def initialize(user)
    user ||= User.new

    # Define CRUD alias action.
    alias_action :create, :read, :update, :destroy, to: :crud

    # Define CRUAR alias action (destroy -> archive/restore).
    alias_action :create, :read, :update, :archive, :restore, to: :cruar

    can :crud,         User
    can :crud,         App
    can :crud,         Group
    can :crud,         Category
    can :crud,         CategoryFormula
    can :crud,         CategoryFormulaHistory
    can :crud,         CategoryRequest
    can :crud,         ResolutionRequest
    can :crud,         ApiManage

  end
end
