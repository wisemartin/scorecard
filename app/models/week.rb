class Week < ActiveRecord::Base
  belongs_to :schedule
  has_one :season, :through => :schedule
  has_many :matchups, :dependent => :destroy
  has_many :score_cards, :through => :matchups
  has_many :rounds, :through => :score_cards
  has_many :scores, :through => :rounds
  has_many :players, :through => :matchups
  has_many :players_weeks_skins
  belongs_to :course
  attr_accessible :schedule_id, :date, :course_id, :matchups_attributes
  accepts_nested_attributes_for :matchups

  scope :active_week, {
      :select => 'weeks.*',
      :joins => 'join matchups mch on mch.week_id = weeks.id and coalesce(home_team_total,visiting_team_total) is not null',
      :order => 'weeks.date desc',
      :limit => 1
  }

  def next_week
    schedule.weeks.order(:date).where(['date > ?', self.date]).first
  end

  def prior_week
    schedule.weeks.order(:date).where(['date < ?', self.date]).last
  end

  def gross_skins
    holes = rounds.first.holes_for_round
    holes.collect do |hole|
      scores.where('rounds.player_id' => [self.players.in_skins(self).collect { |p| p.id }]).group([:score, :hole_id]).select('hole_id, scores.id, scores.round_id, score,count(scores.id) as number').having('number = 1').where(["hole_id=#{hole.id} and scores.score <= #{hole.par}"]).order(:score).first
    end.compact
  end

  def net_skins
    holes = rounds.first.holes_for_round
    holes.collect do |hole|
      scores.where('rounds.player_id' => [self.players.in_skins(self).collect { |p| p.id }]).group([:net_score, :hole_id]).select('hole_id, scores.id, scores.round_id, scores.net_score, count(scores.id) as number').having('number = 1').where(["hole_id=#{hole.id} and scores.net_score < #{hole.par}"]).order(:net_score).first
    end.compact

  end


end
