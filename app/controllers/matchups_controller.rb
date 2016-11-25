class MatchupsController < ApplicationController
  # GET /matchups
  # GET /matchups.json
  layout 'season'
  before_filter :set_session

  def set_session
    mu = Matchup.find(params[:id]) if params[:id]
    if mu
      session[:season_id] = mu.week.schedule.season_id
      session[:league_id] = mu.week.schedule.season.league_id
      session[:organization_id] = mu.week.schedule.season.league.organization_id
    end

  end

  def index
    @matchups = Matchup.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @matchups }
    end
  end

  # GET /matchups/1
  # GET /matchups/1.json
  def show
    @matchup = Matchup.find(params[:id])
    unless @matchup.rounds.collect { |round| round.total_score.to_i }.min > 0 #||true
      redirect_to edit_matchup_path(:id => params[:id])
    else
      home_rounds = @matchup.score_cards.where(:team_id => @matchup.home_team_id).first.rounds.sort_by { |round| round.handicap }
      visiting_rounds = @matchup.score_cards.where(:team_id => @matchup.visiting_team_id).first.rounds.sort_by { |round| round.handicap }
      sm = @matchup.season.scoring_methods.where(:type => 'IndividualMatch').first
      @match_points=[]
      home_rounds.each_with_index do |round, i|
        @match_points << sm.match_points(round, visiting_rounds[i])
      end if sm.present?
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @matchup }
      end
    end
  end

  # GET /matchups/new
  # GET /matchups/new.json
  def new
    @matchup = Matchup.find(params[:id])
    @matchup.score_cards.each do |sc|
      sc.rounds.each do |round|
        round.holes_for_round.each do |hole|
          round.scores.find_or_create_by_hole_id(hole.id)
        end
      end
    end
    @players = @matchup.season.players.order(:first_name)-(@matchup.week.players-@matchup.players-[Player.find_by_first_name('Blind')])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @matchup }
    end
  end

  # GET /matchups/1/edit
  def edit
    @matchup = Matchup.find(params[:id])
    @matchup.score_cards.each do |sc|
      sc.rounds.each do |round|
        round.set_handicap
        round.holes_for_round.each do |hole|
          round.scores.find_or_create_by_hole_id(hole.id)
        end
      end
    end
    @players = @matchup.season.players.order(:first_name)-(@matchup.week.players-@matchup.players-[Player.find_by_first_name('Blind')])
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @matchup }
    end
  end

  # POST /matchups
  # POST /matchups.json
  def create
    @matchup = Matchup.find_or_create_by_id(params[:id]) if params[:id]

    respond_to do |format|
      if @matchup.save
        format.html { redirect_to @matchup, notice: 'Matchup was successfully created.' }
        format.json { render json: @matchup, status: :created, location: @matchup }
      else
        format.html { render action: "new" }
        format.json { render json: @matchup.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /matchups/1
  # PUT /matchups/1.json
  def update
    @matchup = Matchup.find(params[:id])
    @matchup.update_points
    week = Week.new(date: 1.day.from_now)
    @matchup.players.each do |player|
      player.player_league_handicaps.find_or_create_by_season_id(@matchup.season.id).update_attribute(:handicap_index, @matchup.season.handicapping_method.differential(player,week))
    end

    respond_to do |format|
      if @matchup.update_attributes(params[:matchup])
        format.html { redirect_to @matchup, notice: 'Matchup was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @matchup.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /matchups/1
  # DELETE /matchups/1.json
  def destroy
    # @matchup = Matchup.find(params[:id])
    # @matchup.destroy

    respond_to do |format|
      format.html { redirect_to matchups_url }
      format.json { head :no_content }
    end
  end
end
