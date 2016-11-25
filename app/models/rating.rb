class Rating < ActiveRecord::Base
  belongs_to :tee_box
  attr_accessible :course_rating, :slope_rating, :tee_box_id, :type

  def index_for_score(score, eighteen_holes = false)
    course_rating_used = course_rating/(eighteen_holes ? 1 : 2)
    (((score-course_rating_used)*(113.to_f/slope_rating.to_f))*0.96).round(2)
  end
end
