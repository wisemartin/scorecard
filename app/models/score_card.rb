class ScoreCard < ActiveRecord::Base
  belongs_to :matchup
  has_one :week, :through => :matchup
  has_one :schedule, :through => :week
  has_one :season, :through => :schedule
  belongs_to :team
  has_many :rounds, :dependent => :destroy
  belongs_to :course
  attr_accessible :matchup_id, :type, :team_id, :team, :course_id, :course
  after_create :add_rounds

  def add_rounds
    (season.number_playing_each_match).times do |i|
      self.rounds.create(:player => self.team.players[i], :type => front_or_back, :tee_box=>season.tee_box)
    end if matchup.present?
  end


  def front_or_back
    if season.rotate_nines? && course.holes.count == 18 && matchup.week.schedule.last_week.matchups.first.scorecards.first.type=="FrontNineRound"
      "BackNineRound"
    end
    "FrontNineRound"

  end

  def our_score
    return matchup.home_team_total.to_f if matchup.home_team == team && matchup.home_team_total.present?
    return matchup.visiting_team_total.to_f if matchup.visiting_team_total.present?
    nil
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
