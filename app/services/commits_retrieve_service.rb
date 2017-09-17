class CommitsRetrieveService
  attr_accessor :org_name, :repo_name, :start_date, :end_date, :commits

  def initialize(args=nil)
    @octokit = Github::Octokit.new(args[:token])
  end

  def retrieve(org_id, repo_id, start_date, end_date)
    @org_name = @octokit.organization(org_id)[:name]
    @repo_name = @octokit.repository(repo_id)[:name]
    @start_date = dafault(start_date, Time.zone.now.beginning_of_month.strftime('%Y-%m-%d'))
    @end_date = dafault(end_date, Time.zone.now.end_of_month.strftime('%Y-%m-%d'))

    @commits = @octokit.commits(@org_name, @repo_name, @start_date, @end_date)
    self
  end

  def organizations
    @octokit.my_organizations
  end

  def repositories(org_id)
    @octokit.my_repositories(org_id)
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

  private
  def dafault(x, value)
    x.present? ? x : value
  end

end
