class CommitsController < ApplicationController
  before_action :set_org_id, :set_repo_id

  def index
  end

  private
  def set_org_id
    @org_id = index_params[:org_id]
  end

  def set_repo_id
    @repo_id = index_params[:repo_id]
  end

  def index_params
    params.permit(:org_id, :repo_id)
  end

end
