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

  def related_pull_requests
    Constants::DOW
      .reduce({}) { |pull_requests, dow|
        pull_requests[dow] = @commits
                                 .select {|commit| commit.date.strftime('%A') == dow}
                                 .map {|commit| commit.pull_request }
                                 .compact
                                 .uniq
                                 .sort_by { |pr| pr.created_at }
        pull_requests
      }
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
