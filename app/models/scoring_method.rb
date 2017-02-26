class ScoringMethod < ActiveRecord::Base
  belongs_to :season
  attr_accessible :season, :season_id, :points_per_match, :type

  def points_for(matchup)
    nil
  end
end

class IndividualMedal < ScoringMethod
  def points_for(matchup)
    pts={}
    home_team = matchup.score_cards.where(:team_id => matchup.home_team_id).first.rounds.order([:listed,:handicap])
    visiting_team = matchup.score_cards.where(:team_id => matchup.visiting_team_id).first.rounds.order([:listed,:handicap])
    home_team.each_with_index do |round, i|
      opposing_round = visiting_team[i]
      home_net = round.gross_score-round.course_handicap
      visiting_net = opposing_round.gross_score-opposing_round.course_handicap
      case home_net <=> visiting_net
        when -1
          pts[round.player_id]=self.points_per_match
        when 0
          pts[round.player_id]=pts[opposing_round.player_id]=self.points_per_match.to_f/2.0
        else
          pts[opposing_round.player_id]= self.points_per_match
      end
    end
    pts
  end
end

class IndividualMatch < ScoringMethod
  def points_for(matchup)
    pts={}
    home_team = matchup.score_cards.where(:team_id => matchup.home_team_id).first.rounds.sort_by { |rnd| rnd.handicap }
    visiting_team = matchup.score_cards.where(:team_id => matchup.visiting_team_id).first.rounds.sort_by { |rnd| rnd.handicap }
    home_team.each_with_index do |home_round, i|
      visiting_round = visiting_team[i]
      match_pts = match_points(home_round, visiting_round)
      case match_pts[:home_pts] <=> match_pts[:visiting_pts]
        when 1
          pts[home_round.player_id]=self.points_per_match
        when 0
          pts[home_round.player_id]=pts[visiting_round.player_id]=self.points_per_match.to_f/2.0
        else
          pts[visiting_round.player_id]= self.points_per_match
      end
    end
    pts
  end

  def match_points(home_round,visiting_round)
    pts={:home_pts => 0,:visiting_pts => 0,:home_scores=>[],:visiting_scores=>[]}
    holes = home_round.holes_for_round
    home_handicap = [home_round.course_handicap-visiting_round.course_handicap, 0].max
    visiting_handicap = [visiting_round.course_handicap-home_round.course_handicap, 0].max
    holes.each do |hole|
      home_score = home_round.scores.where(:hole_id => hole.id).first
      visiting_score = visiting_round.scores.where(:hole_id => hole.id).first
      home_net = home_score.score-hole.stroke_applied?(home_handicap)
      visiting_net = visiting_score.score-hole.stroke_applied?(visiting_handicap)
      pts[:home_scores]<<{:hole=>hole,:score=>home_score,:net=>home_net}
      pts[:visiting_scores]<<{:hole=>hole,:score=>visiting_score,:net=>visiting_net}
      puts "hole: #{hole.number} home_net: #{home_net} visiting_net: #{visiting_net}"
      case home_net <=> visiting_net
        when -1
          pts[:home_pts]+=1
        when 1
          pts[:visiting_pts]+=1
      end

    end
    pts
  end
end

class TeamMedal < ScoringMethod
  def points_for(matchup)
    pts={}
    home_team = matchup.score_cards.where(:team_id => matchup.home_team_id).first.team
    visiting_team = matchup.score_cards.where(:team_id => matchup.visiting_team_id).first.team
    home_rounds = home_team.score_cards.for_week(matchup.week).collect{|sc| sc.rounds}.flatten
    visiting_rounds = visiting_team.score_cards.for_week(matchup.week).collect{|sc| sc.rounds}.flatten
    home_net = home_rounds.sum { |round| round.gross_score-round.course_handicap }
    visiting_net = visiting_rounds.sum { |round| round.gross_score-round.course_handicap }
    case home_net <=> visiting_net
      when -1
        pts[home_team.id]=(self.points_per_match.to_f/home_team.score_cards.for_week(matchup.week).count)
      when 0
        pts[home_team.id]=pts[visiting_team.id]=(self.points_per_match.to_f/home_team.score_cards.for_week(matchup.week).count.to_f)/2.0
      else
        pts[visiting_team.id]= (self.points_per_match.to_f/home_team.score_cards.for_week(matchup.week).count.to_f)
    end
    pts
  end

end

class TeamMatch < ScoringMethod

end

class PairMedal < ScoringMethod

end

class PairMatch < ScoringMethod

end

class IndividualQuota < ScoringMethod
# Eagle	 	8 Points
# Birdie	 	4 Points
# Par	 	2 Points
# Bogey	 	1 Points



end
class TeamQuota < ScoringMethod

end

class IndividualStableford < ScoringMethod
# Double Eagle  8 Points
# Eagle	 	5 Points
# Birdie	 	2 Points
# Par	 	0 Points
# Bogey	 	-1 Points
# Double Bogey	 	-2 Points


end

class TeamStableford < ScoringMethod

end
