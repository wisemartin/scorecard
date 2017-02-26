class Division < ActiveRecord::Base
  require 'rubin'
  belongs_to :season
  has_many :teams
  attr_accessible :name, :season_id, :season

  def round_robin_schedule(weeks=nil, week=nil, across_divisions=false, extend_schedule=true, random_single_week=false, overwrite=false)
    weeks ||= season.schedule.weeks.order(:date)
    weeks = weeks.where("date >= ?", week.date) if week
    weeks = weeks.select{|wk| wk.matchups.blank?} unless overwrite
    these_teams = season.teams if across_divisions
    these_teams ||= teams
    rrteams = Rubin.new(these_teams.collect { |tm| tm.id })
    round_start = weeks.index(week).to_i
    random_single_week = weeks[rand(these_teams.size-1)] if random_single_week
    this_round = this_week = nil
    rrteams.each_matchup do |home, away, round|
      if this_round.nil? || this_round != round+round_start
        this_round = round+round_start
        this_week = weeks[this_round-1]
        this_week ||= season.schedule.weeks.create(:date => weeks.last.date+7.days) if extend_schedule
        this_week.matchups.destroy_all
      end
      (self.season.number_playing_each_match/2).times do |i|
        #destroy week if overwrite, skip if not.
        if random_single_week && random_single_week!=this_week
          next
        elsif random_single_week
          this_week = week
        end
        break unless this_week
        Matchup.create(:week => this_week, :home_team_id => home, :visiting_team_id => away)
      end

    end
  end

  def add_position_round(week=nil, championship=false)
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
