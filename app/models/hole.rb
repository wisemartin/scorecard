class Hole < ActiveRecord::Base
  belongs_to :tee_box
  has_one :course, :through => :tee_box
  has_many :scores
  attr_accessible :par, :number, :length, :length_unit_of_measure, :handicap_index, :tee_box_id

  def stroke_applied?(hcp)
    return 0 if hcp < 1
    stroke = plus_one = 0
    if hcp > 9
      plus_one = 1
      hcp= hcp-9
    end

    hcps =  if number < 10
              tee_box.front_nine.sort_by { |hol| hol.handicap_index}
            else
              tee_box.back_nine.sort_by { |hol| hol.handicap_index}
            end[0..(hcp-1)]

    stroke = 1 if hcps.include?(self)
    stroke + plus_one
  end

end
