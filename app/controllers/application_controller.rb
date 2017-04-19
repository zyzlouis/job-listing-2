class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def require_is_admin
    if !current_user.admin?
      #.email != 'louis@job2'
      flash[:alert] = 'You are not admin'
      redirect_to root_path
    end
  end
  
end
