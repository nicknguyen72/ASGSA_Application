# frozen_string_literal: true

class MemberPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(id: user.id)
      end
    end
  end

  def index?
    approved?
  end

  def show?
    # Information displayed by show is controlled by the view. But everyone can access.
    approved?
  end

  def new?
    admin_officer?
  end

  def create?
    admin_officer?
  end

  def edit?
    admin_officer_member_info? || unapproved?
  end

  def update?
    admin_officer_member_info? || unapproved?
  end

  def destroy?
    admin_officer?
  end

  def delete_confirmation?
    false
  end

  def admin_officer_member_info?
    user.admin? || user.officer? || record.id == user.id
  end

  def admin_officer?
    user.admin? || user.officer?
  end

  delegate :officer?, to: :user

  delegate :admin?, to: :user

  delegate :approved?, to: :user

  delegate :unapproved?, to: :user
end
