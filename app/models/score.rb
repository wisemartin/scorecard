class Score < ActiveRecord::Base
  belongs_to :hole
  belongs_to :round
  has_one :player, :through => :round
  has_one :score_card, :through => :round
  has_one :team, :through => :score_card
  has_one :season, :through => :team
  has_one :handicapping_method, :through => :season
  has_one :tee_box, :through => :hole
  has_one :course, :through => :tee_box
  #validates_uniqueness_of :player_id, :scope => [:round_id, :hole_id], :unless=>:player_ok

  attr_accessor :use_handicap
  attr_accessible :score, :hole_id, :round_id, :hole
  scope :for_season, lambda { |season_id| {:select => "scores.*", :joins => "join rounds rsc on scores.round_id = rsc.id join score_cards scsc on scsc.id = rsc.score_card_id join teams tsc on tsc.id = scsc.team_id join divisions dsc on dsc.id = tsc.division_id and dsc.season_id = #{season_id}"} }
  scope :all_by_week, :select => 'sum(scores.score) as score, round_id, max(hole_id) as hole_id', :group => 'round_id'
  scope :through_date, lambda { |dateval| {:select => 'sum(scores.score) as score, rnd.player_id, rnd.id as round_id, wnd.date as week',
                                           :group => 'rnd.id', :conditions => "wnd.date < '#{dateval}'",
                                           :joins => ["join rounds rnd on rnd.id = scores.round_id",
                                                      "join score_cards scnd on scnd.id = rnd.score_card_id",
                                                      "join matchups mnd on mnd.id = scnd.matchup_id",
                                                      "join weeks wnd on wnd.id = mnd.week_id"
                                           ].join(" ")
  } }

  after_update :update_round_attrs
  after_update :set_net_score

  def update_round_attrs
    if (self.round.scores.count == self.round.holes_for_round.count)&& self.round.scores.collect{|sc| sc.score.to_i}.min > 0
      self.round.update_score_indexes
    end
  end

  def set_net_score
    if score.to_i > 0 && round && round.course_handicap
      update_attribute(:net_score, score-hole.stroke_applied?(round.course_handicap))
    end unless changes["net_score"].present?
  end

  def handicapping_score(max_score_type=3, max_hole_score_amount=0)
    max_score_for_hole = 50
    case max_score_type
      when 1 #to Par
        max_score_for_hole = par+max_hole_score_amount
      when 2 #flat amount
        max_score_for_hole = max_hole_score_amount
      else #esc
        hcp = 4
        hcp = self.round.handicap/5 if self.round.handicap.present?
        max_score_for_hole = (hcp <= 1.0 ? par+2 : 6+hcp.to_i )
    end
    return [score,max_score_for_hole].min

  end
  def esc_score
    handicapping_score(3)
  end

  def par
     hole.par
  end


end

