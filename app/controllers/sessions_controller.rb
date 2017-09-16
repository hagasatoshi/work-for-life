class SessionsController < ApplicationController
  def callback
    token = request.env['omniauth.auth'][:credentials][:token]
    default_repository = CommitsRetrieveService
                             .new(token: token)
                             .default_repository_information

    redirect_to org_repo_commits_path(org_id: default_repository[:org_id], repo_id: default_repository[:repo_id])
  end

end
