module CommitsHelper
  def circle_style(commit_count)
    width = Constants::CIRCLE_SIZE * (commit_count / @max_count)
    height = width
    left = (-1) * (width / 2)
    top = 32 - (width / 2)
    "width: #{width.to_s}px; height: #{height.to_s}px; left: #{left.to_s}px; top: #{top.to_s}px;"
  end
end
