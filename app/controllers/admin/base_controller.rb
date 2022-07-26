class Admin::BaseController < ApplicationController
  before_action :check_admin
  before_action :require_login

  private

  def not_authenticated
    redirect_to admin_login_path
  end

  def check_admin
    redirect_to root_path unless current_user.admin?
  end
end
