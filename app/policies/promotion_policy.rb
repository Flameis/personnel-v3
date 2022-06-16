class PromotionPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def new?
    user&.has_permission?("promotion_add") ||
      user&.has_permission?("promotion_add_any") ||
      user&.has_permission?("admin")
  end

  def create?
    (record.user && user&.has_permission_on_user?("promotion_add", record.user)) ||
      user&.has_permission?("promotion_add_any") ||
      user&.has_permission?("admin")
  end

  def update?
    create?
  end

  def destroy?
    create?
  end
end
