class Partner < ActiveRecord::Base
  has_many :players_teams
  has_many :players
  has_and_belongs_to_many :teams, :join_table => 'players_teams'

  # attr_accessible :title, :body
end
