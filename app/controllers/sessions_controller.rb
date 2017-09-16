class SessionsController < ApplicationController
  def callback
    auth = request.env['omniauth.auth']
    puts auth
    redirect_to root_path
  end

end
