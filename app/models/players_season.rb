class PlayersSeason < ActiveRecord::Base
  belongs_to :player
  belongs_to :season
  has_many :players_weeks_skins
  has_many :player_league_handicaps

  attr_accessible :player_id, :season_id, :fees_paid, :skins_paid
  after_create :create_player_league_handicap

  def create_player_league_handicap
    PlayerLeagueHandicap.find_or_create_by_player_id_and_season_id(self.player_id, self.season_id)
  end
end
