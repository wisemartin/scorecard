class PlayersSeason < ActiveRecord::Base
  belongs_to :player
  belongs_to :season

  attr_accessible :player_id, :season_id, :fees_paid, :skins_paid
end
