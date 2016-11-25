class PlayerLeagueHandicap < ActiveRecord::Base
  belongs_to :player
  belongs_to :season
  has_one :league, :through => :season
  # attr_accessible :title, :body
end
