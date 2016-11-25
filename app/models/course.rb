class Course < ActiveRecord::Base
  has_many :tee_boxes
  has_many :score_cards
  has_many :seasons
  attr_accessible :name, :city, :state_or_province, :country, :private, :user_id

  def front_nine
     tee_boxes.collect{|tee_box| tee_box.holes.where('number < 10').order([:tee_box_id,:number])}
  end

  def back_nine
    tee_boxes.collect{|tee_box| tee_box.holes.where('number between 10 and 18').order([:tee_box_id,:number])}
  end

  #nice little helper methods... don't know that they'll be used much
  TeeBox.available_colors.each do |color|
    somemethod = "#{color}_tee_box"
    define_method(somemethod) do
       tee_boxes.where(:color=>color).first
    end
  end

end
