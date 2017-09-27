class CommitsRetrieveService
  attr_accessor :org_name, :repo_name, :from_date_val, :to_date_val, :interval, :commits, :pull_requests

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
    @pull_requests = @octokit.pull_requests(@org_name, @repo_name, from_date)
    if @commits.present? && @pull_requests.present?
      set_parent_child_relation!(@commits, @pull_requests)
    end

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
  def set_parent_child_relation!(commits, pull_requests)
    pull_requests.each do |pr|
      puts "loading..... pr commits"
      pr_commits = @octokit.pr_commits(@org_name, @repo_name, pr.number)
      target_commits = commits.select { |target_commit| pr_commits.map {|pr_commit| pr_commit.sha} .include?(target_commit.sha) }
      target_commits.each do |target_commit|
        target_commit.pull_request = pr
      end
      pr.commits.concat(target_commits)
    end
  end


  def dafault(x, value)
    x.present? ? x : value
  end

end
