class UserController < ApplicationController
  before_filter :login_required

  def approve
    @users = Author.find_all_by_approved_by_id nil
  end

end

