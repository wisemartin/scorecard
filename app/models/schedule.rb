class Schedule < ActiveRecord::Base
  has_many :weeks, :dependent => :destroy
  has_many :matchups, :through=>:weeks
  has_many :rounds, :through=>:matchups
  belongs_to :season
  attr_accessible :season_id, :weeks



  def year
    weeks.first.date.year
  end

  def last_week
    self.weeks.last
  end
end
