class TeeBox < ActiveRecord::Base
  belongs_to :course
  has_many :ratings
  has_one :mens_rating
  has_one :womens_rating
  has_many :holes
  attr_accessible :name, :color, :course_id, :holes

  def self.available_colors
    %w(black blue white yellow red gold silver orange purple brown green)
  end


  def front_nine
    holes.where('number < 10').order([:tee_box_id, :number])
  end

  def back_nine
    holes.where('number between 10 and 18').order([:tee_box_id, :number])
  end


end
