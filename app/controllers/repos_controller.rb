class ReposController < ApplicationController

  def index
    token = session[:access_token]
    raise ArgumentError unless token.present?

    repositories = CommitsRetrieveService
                       .new(token: token)
                       .repositories(index_params[:org_id].to_i)
    default_repository = repositories.first

    render partial: 'shared/picklist', locals: {
        pick_list_id: 'pick_repo', type1: 'info', type2: 'repo',
        default_value: default_repository[:id].to_i, default_label: default_repository[:name],
        values: view_context.repo_picklist(repositories)
    }
  end

  private
  def index_params
    params.permit(:org_id)
  end

end
