class HandicappingMethod < ActiveRecord::Base
  belongs_to :season
  attr_accessible :number_used, :number_considered, :handicap_percent, :use_ratings, :minimum_considered, :exclude_extremes, :season_id, :use_usga_schedule, :ignore_unopposed_rounds, :max_handicap, :allow_positive_handicap, :callaway, :callaway_percent, :rollover_season, :rollover_number_weeks,
                  :limit_to_max_hole_score, :max_hole_score_type, :max_hole_score_amount

  def differential(player, week=nil)
    #number of scores to use
    return 0.0 if player.first_name == 'Blind'
    week ||= Week.new(:date => 0.days.ago)

    total = get_total(player, week)

    if total.present?
      total = total.sort_by { |rnd| self.season.present? ? rnd.total_score : rnd.esc_score }
      total = total[0.. (self.scores_to_use(total.count)-1)]
      hcpt = ((total.sum { |rnd| self.season.present? ? rnd.score_index : rnd.hin })/total.size).round(2)
      hcpt = [0.0, hcpt].max unless self.allow_positive_handicap?
      hcpt = [hcpt, max_handicap].min if max_handicap.present?
      return hcpt
    end
    0.0
  end

  def scores_for(player, season = nil, week=nil)
    return [] if season.blank?
    player.rounds.for_season(season).where(["total_score is not null and rounds.date < ?", week.date]).order("rounds.date desc").limit(self.number_considered)
  end

  def get_total(player, week)
    #scores used in the calculation for handicap
    prior_season = two_seasons_ago = nil
    prior_season = season.prior_season if self.rollover_season? && self.season
    two_seasons_ago = prior_season.prior_season if prior_season

    total = scores_for(player, season, week)
    total = nil if total && (total.size < self.number_considered && (self.rollover_season? && total.size < self.rollover_number_weeks))||(total.size < self.minimum_considered && (!self.rollover_season?))
    total ||= (scores_for(player, season, week)|scores_for(player, prior_season, week)).sort_by { |score| score.date }.reverse if self.season
    total = nil if total && (total.size < self.number_considered && (self.rollover_season? && total.size < self.rollover_number_weeks))||(total.size < self.minimum_considered && (!self.rollover_season?))
    total ||= (scores_for(player, season, week)|scores_for(player, prior_season, week)|scores_for(player, two_seasons_ago, week)).sort_by { |score| score.date }.reverse if self.season
    total ||= player.rounds.where(["esc_score is not null and date < ?", week.date]).order("date desc").limit(20)
    total[0.. (self.number_considered-1)]
  end

  def scores_to_use(total_number=0)
    if use_usga_schedule?
      case total_number
        when 0, 1
          0
        when 2, 3, 4
          1
        when 5, 6, 7
          2
        when 8, 9, 10
          3
        when 11, 12
          4
        when 13, 14
          5
        when 15, 16
          6
        when 17
          7
        when 18
          8
        when 19
          9
        else
          10
      end
    else
      [((self.number_used.to_f/self.number_considered.to_f)*total_number.to_f).round, total_number].min
    end
  end


end
