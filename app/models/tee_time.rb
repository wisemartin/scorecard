class TeeTime < ActiveRecord::Base
  has_many :matchup
  belongs_to :season
  # attr_accessible :title, :body
end
