class CommitsCalculateService
  def initialize(args=nil)
    @commits = args[:commits]
  end

  def calculate
    @commit_counts = init_commit_count
    @commits.each do |commit|
      sum_up(commit)
    end
    self
  end

  def commit_counts
    @commit_counts
  end

  def max_count
    count = 0
    Constants::DOW.each do |dow|
      Constants::TIME_ARRAY.each do |time_desc|
        count = (@commit_counts[dow][time_desc] > count ? @commit_counts[dow][time_desc] : count)
      end
    end
    count
  end

  private
  def init_commit_count
    commit_counts = {}
    Constants::DOW.each do |dow|
      commit_counts[dow] = {}
      Constants::TIME_ARRAY.each do |time_desc|
        commit_counts[dow][time_desc] = 0
      end
    end
    commit_counts
  end

  def sum_up(commit)
    dow = commit.date.strftime('%A')
    commit_time = commit.date.strftime('%H').to_i
    @commit_counts[dow][Constants::TIME_ARRAY[commit_time]] += 1
  end

end
