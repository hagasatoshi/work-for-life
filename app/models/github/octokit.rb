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
        .map {|organization| organization.to_h}
  end

  def repositories(organization)
    @client
        .repositories(organization)
        .map {|repository| repository.to_h}
  end

  def commits(organization, repository, start_date, end_date)
    @client
        .commits_between("#{organization}/#{repository}", start_date, end_date)
        .map {|commit| commit.to_h}
  end

end