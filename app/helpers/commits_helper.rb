module CommitsHelper
  def circle_style(commit_count)
    width = Constants::CIRCLE_SIZE * (commit_count / @max_count)
    height = width
    left = (-1) * (width / 2)
    top = 32 - (width / 2)
    "width: #{width.to_s}px; height: #{height.to_s}px; left: #{left.to_s}px; top: #{top.to_s}px;"
  end

  def organization_picklist
    [{label: 'org1', value: '1'},{label: 'org2', value: '2'},{label: 'org3', value: '3'}]
  end

  def repository_picklist
    [{label: 'repo1', value: '1'},{label: 'repo2', value: '2'},{label: 'repo3', value: '3'}]
  end

  def from_date_picklist
    [
        {label: '2017-01-01', value: '2017-01-01'}, {label: '2017-02-01', value: '2017-02-01'}, {label: '2017-03-01', value: '2017-03-01'},
        {label: '2017-04-01', value: '2017-04-01'}, {label: '2017-05-01', value: '2017-05-01'}, {label: '2017-06-01', value: '2017-06-01'},
        {label: '2017-06-01', value: '2017-07-01'}, {label: '2017-08-01', value: '2017-08-01'}, {label: '2017-09-01', value: '2017-09-01'}
    ]
  end

  def interval_picklist
    [{label: '１週間', value: 'week'}, {label: '１ヶ月', value: 'month'}]
  end

end
