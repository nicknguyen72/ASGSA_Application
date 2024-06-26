# frozen_string_literal: true

class MemberRolePolicy < ApplicationPolicy
  # class Scope < Scope
  #   def resolve
  #     if user.admin? # Assuming `admin` is a method that determines if a user is an admin
  #       scope.all
  #     else
  #       scope.where(id: user.id)
  #     end
  #   end
  # end

  def index?
    admin?
  end

  def show?
    admin?
  end

  def new?
    admin?
  end

  def create?
    admin?
  end

  def edit?
    admin?
  end

  def update?
    admin?
  end

  def destroy?
    admin?
  end

  def approval?
    admin_officer?
  end

  def approve?
    admin_officer?
  end

  def reject?
    admin_officer?
  end

  # def admin_officer_member_info?
  #   user.admin? || user.officer? || record.id == user.id
  # end

  def admin_officer?
    user.admin? || user.officer?
  end

  delegate :admin?, to: :user
end
