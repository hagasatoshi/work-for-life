class Github::Octokit
  def initialize(access_token)
    @client = Octokit::Client.new(
      client_id: ENV['GITHUB_KEY'], client_secret: ENV['GITHUB_SECRET'], access_token: access_token
    )
  end

  def login_user_name
    @client.user.login
  end

  def my_organizations
    @client.organizations
        .map { |organization|
          {id: organization[:id], name: organization[:login]}
        }
        .sort {|a, b| a[:id] <=> b[:id]}
  end

  # 自分がcontributorになっているもののみを取得したいが、
  # レスポンスを考慮して参照できるものすべてを取得する
  def my_repositories(org_id)
    @client
        .org_repos(org_id, {type: 'member'})
        .map { |repository|
          {id: repository[:id], name: repository[:name]}
        }
        .sort {|a, b| a[:id] <=> b[:id]}
  end

  def commits(organization, repository, start_date, end_date)
    @client
        .commits_between("#{organization}/#{repository}", start_date, end_date)
        .map {|commit| commit.to_h}
  end

end