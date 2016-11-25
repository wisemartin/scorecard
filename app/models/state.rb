class State < ActiveRecord::Base
  has_many :organizations
  # attr_accessible :title, :body
end
