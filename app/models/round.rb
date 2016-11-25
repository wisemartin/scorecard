class Round < ActiveRecord::Base
  belongs_to :score_card
  has_one :team, :through => :score_card
  has_one :matchup, :through => :score_card
  has_one :week, :through => :matchup
  has_one :schedule, :through => :matchup
  has_one :season, :through => :schedule
  has_many :scores
  belongs_to :tee_box
  belongs_to :player
  has_one :course, :through => :tee_box
  attr_accessible :date, :player_id, :score_card_id, :player, :score_card, :tee_box, :tee_box_id, :type
  attr_accessor :hin_calc

  scope :for_season, lambda { |season| {:select => "rounds.*", :joins => ["join score_cards scsc on scsc.id = rounds.score_card_id join matchups tsc on tsc.id = scsc.matchup_id join weeks wsc on wsc.id = tsc.week_id join schedules dsc on dsc.id = wsc.schedule_id and dsc.season_id = #{season.id}"]} }


  def hcp_index
    hcp_index = nil
    score_to_use = (self.hin_calc ? esc_score : total_score)
    if total_score.present?
      hcp_index = ((score_to_use - rating)*slope)*(self.handicapping_method.handicap_percent.to_f/100.0)
    end
    hcp_index.to_f.round(2)
  end

  def course_handicap
    hc = self.handicap if self.handicap.present?
    set_handicap unless hc
    hc = handicap*(course_rating.slope_rating/113.0) if handicapping_method.use_ratings?
    hc.round
  end

  def starting_index
    hin_calc=true
    sin = handicapping_method.differential(self.player, self.week)
    hin_calc=false
    sin
  end

  def set_handicap
    self.update_attribute(:handicap, handicapping_method.differential(self.player, self.week)) unless changes["handicap"].present?
  end

  def week
    return self.score_card.matchup.week if self.score_card && self.score_card.matchup
    return Week.new(:date => curdate())
  end

  def handicapping_method
    return HandicappingMethod.find(1) if (hin_calc || score_card.matchup.blank?)
    score_card.matchup.week.schedule.season.handicapping_method
  end

  def course_rating
    course_rating = tee_box.ratings.select { |rating| rating.type =~ /^#{self.player.ratings_gender}/i }.first
    course_rating ||= tee_box.ratings.first
    course_rating
  end

  def rating
    rating = par.to_f
    if handicapping_method.use_ratings?
      rating = course_rating.course_rating
      rating = rating/2 if tee_box.holes.count == 18
    end
    rating
  end

  def slope
    slope = 1.0
    if handicapping_method.use_ratings?
      slope = 113.to_f/course_rating.slope_rating.to_f
    end
    slope
  end

  def update_score_indexes
    if self.scores.count==self.holes_for_round.count && self.scores.collect { |score| score.score.to_i }.min > 0
      if handicapping_method.limit_to_max_hole_score?
        update_attribute(:total_score, scores.sum { |sc| sc.handicapping_score(handicapping_method.max_hole_score_type, handicapping_method.max_hole_score_amount) })
      else
        update_attribute(:total_score, scores.sum { |sc| sc.score })
      end
      update_attribute(:gross_score, scores.sum { |sc| sc.score })
      update_attribute(:esc_score, scores.sum { |sc| sc.esc_score })
      reload
      update_attribute(:score_index, self.hcp_index)
      update_hin
    end
  end

  def update_hin
    self.hin_calc = true
    update_attribute(:hin, self.hcp_index)
    self.hin_calc = false
  end

  def par
    holes_for_round.sum { |hole| hole.par }
  end

  def update_total_score
    if scores.count == 9 && scores.collect { |sc| sc.score.to_i }.min > 0
      update_attribute(:total_score, score.score)
    end
  end

  def net_score
    self.gross_score-self.course_handicap
  end

  def holes_for_round
    tee_box.holes
  end

end

class FrontNineRound < Round

  def holes_for_round
    tee_box.front_nine
  end
end

class BackNineRound < Round

  def holes_for_round
    tee_box.back_nine
  end

end
