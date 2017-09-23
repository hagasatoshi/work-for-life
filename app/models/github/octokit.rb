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
        .map { |commit|
          {author: commit[:commit][:author][:email], date: commit[:commit][:committer][:date].in_time_zone('Asia/Tokyo'),
            message: commit[:commit][:message]}
        }
  end

  def pull_requests(organization, repository, from_date)
    @client.auto_paginate = false
    all_prs = @client
                  .pull_requests("#{organization}/#{repository}", {state: 'all', sort: 'updated', direction: 'desc'})
                  .map { |pr| PullRequest.new(pr)}
    result = @client.last_response.rels[:next].get
    while result.rels[:next]
      result = result.rels[:next].get
      all_prs.concat(result.data.map { |pr| PullRequest.new(pr)})

      if all_prs.last.updated_at < Time.zone.parse(from_date)
        break
      end
    end
    @client.auto_paginate = true
    all_prs
  end

  class PullRequest
    attr_accessor :id, :title, :created_at, :updated_at
    def initialize(gh_raw)
      @id = gh_raw[:id]
      @title = gh_raw[:title]
      @created_at = gh_raw[:created_at].in_time_zone('Asia/Tokyo')
      @updated_at = gh_raw[:updated_at].in_time_zone('Asia/Tokyo')
    end
  end

end