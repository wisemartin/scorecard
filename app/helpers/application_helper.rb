module ApplicationHelper
  def current_league
    League.find(session[:league_id])
  end

  def current_season
    Season.find(session[:season_id])
  end

  def convert_dates(first,second)
    [first,second].collect do |dt|
      dvs = dt.split("/")
      [dvs[2],dvs[0],dvs[1]].join("-").to_date
    end
  end
end
