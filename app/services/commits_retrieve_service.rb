class CommitsRetrieveService
  attr_accessor :org_name, :repo_name, :from_date_val, :to_date_val, :interval, :commits

  def initialize(args=nil)
    @octokit = Github::Octokit.new(args[:token])
  end

  def retrieve(org_id, repo_id, from_date, interval)
    @org_name = @octokit.organization(org_id)[:name]
    @repo_name = @octokit.repository(repo_id)[:name]
    @from_date_val = Time.zone.parse(dafault(from_date, Time.zone.today.beginning_of_week.yesterday.strftime('%Y-%m-%d')))
    @interval = dafault(interval, 'week')
    @to_date_val = @from_date_val + (@interval == 'week' ? 1.weeks : 1.months)
    @commits = @octokit.commits(@org_name, @repo_name, @from_date_val.strftime('%Y-%m-%d'), @to_date_val.strftime('%Y-%m-%d'))
    self
  end

  def organizations
    @octokit.my_organizations
  end

  def repositories(org_id)
    @octokit.my_repositories(org_id)
  end

  def default_repository_information
    my_organizations = @octokit.my_organizations
    return nil unless my_organizations.present?

    default_org = my_organizations.first

    my_repositories = @octokit.my_repositories(default_org[:id])
    return nil unless my_repositories.present?

    default_repository = my_repositories.first

    {org_id: default_org[:id], org_name: default_org[:name],
     repo_id: default_repository[:id], repo_name: default_repository[:name]}
  end

  private
  def dafault(x, value)
    x.present? ? x : value
  end

end
