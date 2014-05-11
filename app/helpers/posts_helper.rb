module PostsHelper
  def new_line(s)
    # "\n" を "<br/>" に変換する
    html_escape(raw(h(s).gsub(/(\r\n?)|(\n)/, "<br />")))
    #s.gsub(/\r\n|\r|\n/, "<br />")
  end
end
