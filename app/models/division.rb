class Division < ActiveRecord::Base
  require 'rubin'
  belongs_to :season
  has_many :teams
  attr_accessible :name, :season_id, :season

  def round_robin_schedule(weeks=nil, week=nil)
    weeks ||= self.teams.count-1
    rrteams = Rubin.new(self.teams.collect { |tm| tm.id })
    round_start, i = 0
    rrteams.each_matchup do |home, away, round|
      this_round = round+round_start
      (self.season.number_playing_each_match/2).times do |i|
        Matchup.create(:week => season.weeks[this_round-1], :home_team_id => home, :visiting_team_id => away)
      end

    end
  end

  def add_position_round(week=nil, championship=nil)
    week ||=Game.first(:order => "week desc").week+1
    d1_teams = teams.sort_by { |team| team.team_total_score }
    matchups = []
    (d1_teams.count/2).times do
      matchups << [d1_teams.pop, d1_teams.pop]
    end
    games = []
    matchups.each_with_index do |match, i|
      tees=(self.id.odd? ? 0 : 1)
      games << Game.create(:week => week, :home_team_id => match[0].id, :visiting_team_id => match[1].id, :course_id => Game.where("week = #{week-2}").first.course_id, :tee_time => (2*i)+tees)
    end
    games.collect { |game| [game.home_team.team_name, game.visiting_team.team_name, game.tee_time] }
  end

  def self.championship_round(week=nil)
    week ||=Game.first(:order => "week desc").week+1
    d1_teams = Division.first.teams.sort_by { |team| team.team_total_score }
    d2_teams = Division.last.teams.sort_by { |team| team.team_total_score }

    matchups = []
    games = []

    d1_teams.each_with_index do |team, i|
      games << Game.create(:week => week, :home_team_id => team.id, :visiting_team_id => d2_teams[i].id, :course_id => Game.where("week = #{week-2}").first.course_id, :tee_time => i)
    end
    games.collect { |game| [game.home_team.team_name, game.visiting_team.team_name, game.tee_time] }

  end

end
