class Organization < ActiveRecord::Base
  has_many :leagues, :dependent => :destroy
  belongs_to :state
  has_and_belongs_to_many :players
  attr_accessible :name, :city, :state_id
end
