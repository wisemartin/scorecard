class Team < ActiveRecord::Base
  belongs_to :division
  has_many :score_cards
  has_and_belongs_to_many :players
  has_and_belongs_to_many :partners, :join_table => 'players_teams'
  has_one :season, :through=>:division
  has_one :league, :through=>:season
  has_many :home_matches, :class_name =>'Matchup',:foreign_key =>:home_team_id
  has_many :visiting_matches, :class_name =>'Matchup',:foreign_key =>:visiting_team_id

  attr_accessible :name, :division_id, :division, :players, :players_attributes

  accepts_nested_attributes_for :players

  #before_save :set_team_name

  def set_team_name
    return true if team_name.present?
    self.team_name= players.collect{|player| player.last_name.titleize}.join(" - ")
  end

  def team_handicap
    self.players.collect{|ply| ply.weighted_handicap.to_f}.sum
  end

  def team_total
    home_matches.sum{|matchup| matchup.home_team_total.to_f}+visiting_matches.sum{|matchup| matchup.visiting_team_total.to_f}
  end

  def team_id
    season.teams.order(:id).index(self)+1
  end


end
