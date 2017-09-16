class CommitsController < ApplicationController
  def index
    token = session[:access_token]
    raise ArgumentError unless token.present?

    commits = CommitsRetrieveService
                   .new(token: token)
                   .commits(
                       index_params[:org_id], index_params[:repo_id],
                       index_params[:start_date], index_params[:end_date]
                   )
    @commit_count = CommitsCalculateService
                        .new(commits: commits)
                        .calculate
  end

  private
  def index_params
    params.permit(:org_id, :repo_id, :start_date, :end_date)
  end

end
