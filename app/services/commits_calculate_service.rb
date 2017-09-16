class CommitsCalculateService
  def initialize(args=nil)
    @commits = args[:commits]
    @commit_count = init_commit_count
  end

  def calculate
    @commits.each do |commit|
      sum_up!(commit)
    end
    @commit_count
  end

  private
  def init_commit_count
    commit_count = {}
    Constants::DOW.each do |dow|
      commit_count[dow] = {}
      Constants::TIME_ARRAY.each do |time_desc|
        commit_count[dow][time_desc] = 0
      end
    end
    commit_count
  end

  def sum_up!(commit)
    dow = commit[:date].strftime('%A')
    commit_time = commit[:date].strftime('%H').to_i
    @commit_count[dow][Constants::TIME_ARRAY[commit_time]] += 1
  end

end
