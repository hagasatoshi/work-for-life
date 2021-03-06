class Github::Octokit
  def initialize(access_token)
    @client = Octokit::Client.new(
      client_id: ENV['GITHUB_KEY'], client_secret: ENV['GITHUB_SECRET'], access_token: access_token
    )
    @client.auto_paginate = true
  end

  def login_user_name
    @client.user.login
  end

  def my_organizations
    @client.list_organizations
        .select {|org| @client.org_repos(org[:id], {type: 'member'}).present? }
        .map { |organization|
          {id: organization[:id], name: organization[:login]}
        }
        .sort {|a, b| b[:id] <=> a[:id]}
  end

  def my_repositories(org_id)
    @client
        .org_repos(org_id, {type: 'member'})
        .map { |repository|
          {id: repository[:id], name: repository[:name]}
        }
        .sort {|a, b| b[:id] <=> a[:id]}
  end

  def organization(org_id)
    org = @client.organization(org_id.to_i)
    {id: org[:id], name: org[:login]}
  end

  def repository(repo_id)
    repo = @client.repository(repo_id.to_i)
    {id: repo[:id], name: repo[:name]}
  end

  def commits(organization, repository, start_date, end_date)
    @client
        .commits("#{organization}/#{repository}", since: "#{start_date}T00:00:00+09:00", until: "#{end_date}T00:00:00+09:00")
        .map {|commit| Commit.new(commit)}
  end

  def pull_requests(organization, repository, from_date)
    @client.auto_paginate = false
    all_prs = @client
                  .pull_requests("#{organization}/#{repository}", {state: 'all', sort: 'updated', direction: 'desc'})
                  .map { |pr| PullRequest.new(pr)}
                  .sort_by { |pr| pr.created_at }
    return unless @client.last_response.rels[:next]

    result = @client.last_response.rels[:next].get
    while result.rels[:next]
      puts 'loading.... pull requests'
      result = result.rels[:next].get
      all_prs.concat(result.data.map { |pr| PullRequest.new(pr)})

      if all_prs.last.updated_at < from_date
        break
      end
    end
    @client.auto_paginate = true
    all_prs
  end

  def pr_commits(organization, repository, pr_number)
    @client
        .pull_request_commits("#{organization}/#{repository}", pr_number)
        .map {|commit| Commit.new(commit)}
  end

  class PullRequest
    attr_accessor :number, :title, :assignee, :created_at, :updated_at, :commits
    def initialize(gh_raw)
      @number = gh_raw[:number]
      @title = gh_raw[:title]
      @assignee = gh_raw[:assignees].present? ? gh_raw[:assignees][0][:login] : ''
      @created_at = gh_raw[:created_at].in_time_zone('Asia/Tokyo')
      @updated_at = gh_raw[:updated_at].in_time_zone('Asia/Tokyo')
      @commits = []
    end
  end

  class Commit
    attr_accessor :sha, :pull_request, :email, :date, :message
    def initialize(gh_raw)
      @sha = gh_raw[:sha]
      @email = gh_raw[:commit][:author][:email]
      @date = gh_raw[:commit][:committer][:date].in_time_zone('Asia/Tokyo')
      @message = gh_raw[:commit][:message]
    end
  end
end