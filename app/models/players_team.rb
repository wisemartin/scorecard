class PlayersTeam < ActiveRecord::Base
  belongs_to :team
  belongs_to :player
  belongs_to :partner
  attr_accessible :player_id, :team_id, :player, :team
end
