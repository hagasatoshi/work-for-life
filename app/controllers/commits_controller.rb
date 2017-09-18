class CommitsController < ApplicationController
  before_action :redirect_session_invalid
  before_action :set_service, :set_repository_info, :set_commit_counts, :set_max_count, :set_orgs, :set_repos

  def index
  end

  private
  def set_service
    token = session[:access_token]
    raise ArgumentError unless token.present?

    @retrieve = CommitsRetrieveService.new(token: token)
                    .retrieve(
                      index_params[:org_id], index_params[:repo_id],
                      index_params[:from_date], index_params[:interval]
                    )
    @calclate = CommitsCalculateService
                        .new(commits: @retrieve.commits)
                        .calculate
  end

  def set_repository_info
    @org_id = index_params[:org_id]
    @org_name = @retrieve.org_name

    @repo_id = index_params[:repo_id]
    @repo_name = @retrieve.repo_name

    @from_date = @retrieve.from_date_val
    @to_date = @retrieve.to_date_val
    @interval = @retrieve.interval
  end

  def set_commit_counts
    @commit_counts = @calclate.commit_counts
  end

  def set_max_count
    @max_count = @calclate.max_count
  end

  def set_orgs
    @orgs = @retrieve.organizations
    redirect_with_error_message 'GitHub Organizationへの登録が無いため実行できません' unless @orgs.present?
  end

  def set_repos
    @repos = @retrieve.repositories(index_params[:org_id].to_i)
    redirect_with_error_message 'GitHub Organizationへの登録が無いため実行できません' unless @repos.present?
  end

  def index_params
    params.permit(:org_id, :repo_id, :from_date, :interval)
  end

end
