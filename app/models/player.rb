class Player < ActiveRecord::Base
  has_many :rounds
  has_many :scores, :through => :rounds
  has_and_belongs_to_many :teams
  has_and_belongs_to_many :seasons
  has_and_belongs_to_many :organizations
  has_many :player_league_handicaps
  has_many :players_seasons
  has_many :players_weeks_skins, :through => :players_seasons

  scope :in_skins, lambda { |week| {:select => 'distinct players.*',
                                    :joins => ["join seasons seas on seas.id = #{week.season.id}",
                                               "join players_seasons psea on psea.player_id = players.id and psea.season_id = seas.id",
                                               "left join players_weeks_skins pws on pws.players_season_id = psea.id and pws.week_id = #{week.id}"
                                    ].join(" "),
                                    :conditions => "pws.id is not null or psea.skins_paid = 1"}
  }

  attr_accessor :handicap, :for_week

  attr_accessible :first_name, :last_name, :email, :phone, :home_address, :city, :state_or_province, :country, :gender
  validates_presence_of :first_name, :last_name


  def full_name
    "#{first_name} #{last_name}".titleize
  end

  def scores_for_season(season)
    scores.for_season(season.id)
  end

  def ratings_gender
    "WomensRating" if gender == 'Female'
    "MensRating"
  end

end