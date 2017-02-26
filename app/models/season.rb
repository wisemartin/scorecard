class Season < ActiveRecord::Base
  belongs_to :league
  belongs_to :course
  has_many :divisions, :dependent => :destroy
  has_many :teams, :through=>:divisions
  has_one :schedule, :dependent => :destroy
  has_many :weeks, :through => :schedule
  has_one :handicapping_method, :dependent => :destroy
  has_many :scoring_methods, :dependent => :destroy
  has_and_belongs_to_many :players
  has_many :players_seasons
  has_many :player_league_handicaps
  belongs_to :tee_box

  attr_accessible :name, :league_id, :start_date, :end_date, :eighteen_holes, :handicapping_method, :scoring_methods, :scoring_methods_attributes, :divisions, :divisions_attributes,:course_id, :roster_size, :limit_subs_to_roster, :number_playing_each_match, :copy_players,
                  :gross_skins, :net_skins, :skins_paid_by_season, :rotate_nines, :handicapping_method_attributes, :wday, :scramble_tee_boxes, :tee_time_start, :tee_time_interval, :tee_box_id
  after_create :make_schedule, :add_players
  after_update :update_schedule
  attr_accessor :copy_players

  accepts_nested_attributes_for :handicapping_method, :scoring_methods, :divisions

  scope :scores_for_player, :select => 'sum(scores.score) as score, player_id, round_id', :group => 'player_id, round_id', :joins => "join rounds on rounds.id = scores.round_id"

  validates_presence_of :name, :league_id, :start_date, :end_date, :handicapping_method, :scoring_methods

  def make_schedule(days_of_weeks=[0])
    wks = ((end_date-start_date)/7).to_i
    update_attribute(:schedule, Schedule.new())
    self.schedule.update_attribute(:weeks, (0..wks).collect { |w| Week.new(:date => start_date+w.weeks, :course_id => course_id) })

  end

  def update_schedule(days_of_weeks=[0])
      wks = ((end_date-start_date)/7).to_i
      self.schedule.update_attribute(:weeks, (0..wks).collect { |w| schedule.weeks.find_or_create_by_date_and_course_id(:date => start_date+w.weeks, :course_id => course_id) })
  end


  def prior_season
    seasons = league.seasons.where(["start_date < ?", (self.start_date)]).order(:start_date).last
  end

  def next_season
    seasons = league.seasons.where(["start_date > ?", (self.start_date)]).order(:start_date).first
  end

  def add_players
    #add_players from prior seasons
    players|prior_season.players.each do |ps|
      self.players_seasons.find_or_create_by_player_id(ps.id)
      plh = self.player_league_handicaps.find_or_create_by_player_id(ps.id)
      pplh = prior_season.player_league_handicaps.where(player_id: ps.id).first
      plh.update_attribute(:handicap_index, pplh.handicap_index) if plh && pplh
    end if self.copy_players

  end


  def add_player(player)
    self.players = self.players << player
    self.save
  end

end
