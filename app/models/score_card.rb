class ScoreCard < ActiveRecord::Base
  belongs_to :matchup
  has_one :week, :through => :matchup
  has_one :schedule, :through => :week
  has_one :season, :through => :schedule
  belongs_to :team
  has_many :rounds, :dependent => :destroy
  has_many :scores, :through=>:rounds
  has_one :course, :through=> :week

  scope :for_week, lambda { |week| {:joins => ["join matchups mch on mch.id = score_cards.matchup_id",
                                               "join weeks wks on mch.week_id = wks.id and wks.id = #{week.id}"].join(" ")} }

  attr_accessible :matchup_id, :type, :team_id, :team, :course_id, :course
  after_create :add_rounds


  accepts_nested_attributes_for :rounds

  def add_rounds
    2.times do |i|
      available_players = team.players-week.players
      self.rounds.create(:player => available_players[i], :type => front_or_back, :tee_box => season.tee_box)
    end if matchup.present?
  end


  def front_or_back
    if season.rotate_nines? && course.holes.count == 18 && matchup.week.prior_week.rounds.present? && matchup.week.prior_week.rounds.first.type=="FrontNineRound"
      "BackNineRound"
    end
    "FrontNineRound"

  end

  def our_score
    begin
      return team.score_cards.for_week(matchup.week).sum { |sc| sc.matchup.home_team_total }.to_f if matchup.home_team == team && matchup.home_team_total.present?
      return team.score_cards.for_week(matchup.week).sum { |sc| sc.matchup.visiting_team_total }.to_f if matchup.visiting_team == team && matchup.visiting_team_total.present?
      return  nil
    rescue StandardError => e
      return nil
    end
    0.0
  end
end

class PracticeScoreCard < ScoreCard

end

class HeadToHeadScoreCard < ScoreCard


end

class TournamentScoreCard < ScoreCard

end

class FunScoreCard < ScoreCard

end
