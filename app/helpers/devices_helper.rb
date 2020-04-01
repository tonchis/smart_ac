module DevicesHelper
  def link_to_change_chart(name, chart_options, chart_id, data_url, html_options = {})
    type = "LineChart"

    onclick = "changeChart(\"#{type}\", \"chart-#{chart_id}\", \"#{data_url}\", #{chart_options.to_json}); event.preventDefault()"
    link_to(name, "#", html_options.merge(onclick: onclick))
  end

  def dashboard_date(str)
    begin
      date = Date.parse(str)
      date.to_s(:long)
    rescue TypeError
      ""
    end
  end
end
