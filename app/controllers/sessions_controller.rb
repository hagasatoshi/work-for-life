class SessionsController < ApplicationController
  before_action :set_repository

  def callback
    session[:access_token] = @token
    redirect_to org_repo_commits_path(org_id: @repository[:org_id], repo_id: @repository[:repo_id])
  end

  private
  def set_repository
    @token = request.env['omniauth.auth'][:credentials][:token]
    @repository = CommitsRetrieveService
                             .new(token: @token)
                             .default_repository_information
    redirect_with_error_message '参照が許可されているGitHub Organizationが存在しないため実行できません' unless @repository.present?
  end

end
