class League < ActiveRecord::Base
  has_many :seasons, :dependent=>:destroy
  belongs_to :organization

  has_many :players, :finder_sql=>['select players.* from leagues join seasons on seasons.league_id = leagues.id',
'join players_seasons on players_seasons.season_id = seasons.id',
'join players on players.id = players_seasons.player_id'].join(" ")

  attr_accessible :name, :domain_identifier, :organization_id


  def current_season
    cs = seasons.select{|season| season.start_date < 0.days.ago.to_date && season.end_date > 0.days.ago.to_date}.first
    cs ||= seasons.order(:end_date).last
  end
end
