module CommitsHelper
  def circle_style(commit_count)
    return 'display: none;' if @max_count == 0 || commit_count == 0

    #コミット数の割合と円の面積比が一致するように割合の平方根をかける
    width = Constants::CIRCLE_SIZE * ((commit_count.to_f / @max_count)**(1/2.0))
    height = width
    left = (-1) * (width / 2)
    top = 32 - (width / 2)
    "width: #{width.to_s}px; height: #{height.to_s}px; left: #{left.to_s}px; top: #{top.to_s}px;"
  end

  def org_picklist(orgs)
    orgs.map {|org| {label: org[:name], value: org[:id].to_s}}
  end

  def repo_picklist(repos)
    repos.map {|repo| {label: repo[:name], value: repo[:id].to_s}}
  end

  def from_date_picklist
    last_sunday = Time.zone.today.beginning_of_week.yesterday
    (0..25)
        .to_a
        .map {|num|
          sunday = last_sunday - num.weeks
          {label: sunday.strftime('%Y-%m-%d'), value: sunday.strftime('%Y-%m-%d')}
        }
  end

  def interval_picklist
    [{label: '１週間', value: 'week'}, {label: '１ヶ月', value: 'month'}]
  end

end
