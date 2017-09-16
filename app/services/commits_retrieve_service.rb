class CommitsRetrieveService
  def initialize(args=nil)
    @octokit = Github::Octokit.new(args[:token])
  end

  #TODO 例外処理はあとでまとめて実施する
  def default_repository_information
    my_organizations = @octokit.my_organizations
    default_org = my_organizations.first

    my_repositories = @octokit.my_repositories(default_org[:id])
    default_repository = my_repositories.first

    {org_id: default_org[:id], org_name: default_org[:name],
     repo_id: default_repository[:id], repo_name: default_repository[:name]}
  end

end
