class PlayersWeeksSkin < ActiveRecord::Base
  belongs_to :players_season
  has_one :player, :through => :players_season
  belongs_to :week
  # attr_accessible :title, :body
end
