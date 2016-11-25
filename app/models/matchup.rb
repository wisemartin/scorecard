class Matchup < ActiveRecord::Base
  belongs_to :week
  has_one :schedule, :through => :week
  has_one :season, :through => :schedule
  has_many :score_cards, :dependent => :destroy
  has_many :rounds, :through=>:score_cards
  has_many :players, :through=>:rounds
  belongs_to :home_team, :class_name => 'Team'
  belongs_to :visiting_team, :class_name => 'Team'
  belongs_to :tee_time
  attr_accessible :week_id, :week, :home_team_id, :visiting_team_id, :home_team_total, :visiting_team_total
  after_create :add_scorecards

  def points(type=:home_team)
    ind = if score_cards.collect { |sc| sc.rounds.collect { |rnd| rnd.points.to_i } }.flatten.sum > 0
            self.send(type).score_cards.where(:matchup_id => self.id).first.rounds.sum(:points)
          else
            individual_points[type]
          end
    ind + team_points[type]
  end

  def home_team_points
    update_attribute(:home_team_total, points(:home_team)) unless home_team_total.present?
    return home_team_total
  end

  def visiting_team_points
    update_attribute(:visiting_team_total, points(:visiting_team)) unless visiting_team_total.present?
    return visiting_team_total
  end

  def update_points
    update_attributes(:home_team_total=>nil,:visiting_team_total=>nil)
    home_team_points
    visiting_team_points
  end


  def sm_points(type='individual')
    scrs={:home_team => 0.0, :visiting_team => 0.0}
    points_collection = self.season.scoring_methods.where("type like '%#{type}%'").collect do |scoring_method|
      scoring_method.points_for(self)
    end
    return scrs if points_collection.compact.blank?
    scrs[:home_team]=home_team_players.sum do |ply|
      points_collection.collect { |hsh| hsh[ply.id].to_f }
    end.sum
    scrs[:visiting_team]=visiting_team_players.sum do |ply|
      points_collection.collect { |hsh| hsh[ply.id].to_f }
    end.sum
    scrs
  end

  def individual_points
    sm_points('individual')
  end

  def team_points
    sm_points('team')

  end


  def add_scorecards
    return score_cards if score_cards.present?
    self.score_cards.create(:team => home_team, :type => 'HeadToHeadScoreCard')
    self.score_cards.create(:team => visiting_team, :type => 'HeadToHeadScoreCard')
  end

  def home_team_display
    home_team.players.collect { |ply| ply.full_name }.join(", ")
  end

  def home_team_initials
    home_team.players.collect { |ply| ""<<ply.first_name[0]<<ply.last_name[0] }.join(", ")
  end

  def home_team_players
     score_cards.where(:team_id=>home_team_id).first.rounds.collect{|sc| sc.player}
  end

  def visiting_team_players
    score_cards.where(:team_id=>visiting_team_id).first.rounds.collect{|sc| sc.player}
  end

  def visiting_team_display
    visiting_team.players.collect { |ply| ply.full_name }.join(", ")
  end

  def visiting_team_initials
    visiting_team.players.collect { |ply| ""<<ply.first_name[0]<<ply.last_name[0] }.join(", ")
  end


end
