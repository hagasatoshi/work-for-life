class CommitsController < ApplicationController
  before_action :set_service, :set_commit_counts, :set_max_count

  def index
  end

  private
  def set_service
    token = session[:access_token]
    raise ArgumentError unless token.present?

    commits = CommitsRetrieveService
                  .new(token: token)
                  .commits(
                      index_params[:org_id], index_params[:repo_id],
                      index_params[:start_date], index_params[:end_date]
                  )
    @calclate = CommitsCalculateService
                        .new(commits: commits)
                        .calculate
  end

  def set_commit_counts
    @commit_counts = @calclate.commit_counts
  end

  def set_max_count
    @max_count = @calclate.max_count
  end

  def index_params
    params.permit(:org_id, :repo_id, :start_date, :end_date)
  end

end
