class SeasonsController < ApplicationController
  helper ApplicationHelper
  # GET /seasons
  # GET /seasons.json
  before_filter :require_auth, :only => [:new, :edit, :create]
  before_filter :set_session, :except => [:new, :create]

  def set_session
    mu = Season.find(params[:id]) if params[:id]
    mu ||= Season.find(session[:season_id])
    if mu
      session[:season_id] = mu.id
      session[:league_id] = mu.league_id
      session[:organization_id] = mu.league.organization_id
    end
  end

  def index
    session[:league_id] = params[:id] if params[:id]
    @league = League.find(session[:league_id])
    @seasons = @league.seasons

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @seasons }
    end
  end

  # GET /seasons/1
  # GET /seasons/1.json
  def show
    @season = Season.find(session[:season_id])

    @divisions = @season.divisions
    @teams = @season.divisions.collect { |div| div.teams.order("id desc").sort_by { |team| team.team_total }.reverse }.flatten
    @weeks = @season.schedule.weeks.order(:date)
    @max_week = @weeks.last


    @season ||= Season.find(session[:season_id])
    @schedule = @season.schedule
    render 'teams/index', :layout => 'season'
    # respond_to do |format|
    #   format.html # show.html.erb
    #   format.json { render json: @season }
    # end
  end

  # GET /seasons/new
  # GET /seasons/new.json
  def new
    if params[:course_id]
      @season = Season.new(params[:season])
      @show_the_js_link = true
      respond_to do |format|
        format.js {}
      end
    else
      session[:league_id]=params[:id] if params[:id]
      @season = Season.new(:league_id => session[:league_id], :start_date => 0.days.ago, :end_date => 0.days.ago)
      old_season = League.find(session[:league_id]).seasons.last
      hc = old_season.handicapping_method if old_season
      hc ||= HandicappingMethod.find(2)
      @season.handicapping_method= hc.dup
      @season.divisions = [Division.new(), Division.new(), Division.new()]
      @week=Week.new()
      @season.scoring_methods = ScoringMethod.where('season_id is null').order(:type).collect { |sm| sm.dup }
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @season }
      end
    end


  end

  def add_division

  end

  # GET /seasons/1/edit
  def edit
    @season = Season.find(params[:id])
    @week = @season.schedule.weeks.first
  end

  # POST /seasons
  # POST /seasons.json
  def create
    params[:season][:start_date] = Date.strptime(params[:season][:start_date], "%m/%d/%Y")
    params[:season][:end_date] = Date.strptime(params[:season][:end_date], "%m/%d/%Y")
    params[:season][:handicapping_method_attributes] = params[:handicapping_method]
    params[:season].delete(:wday)
    params[:season].delete('tee_time_start(5i)')

    @season = Season.new(params[:season])


    #Create divisions if any are added, else default to the below.

    respond_to do |format|
      if @season.save
        @season.reload
        session[:season_id]=@season.id
        set_session
        format.html { redirect_to @season, notice: 'Season was successfully created.' }
        format.json { render json: @season, status: :created, location: @season }
      else
        format.html { render action: "new" }
        format.json { render json: @season.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /seasons/1
  # PUT /seasons/1.json
  def update
    @season = Season.find(params[:id])
    params[:season][:start_date] = Date.strptime(params[:season][:start_date], "%m/%d/%Y")
    params[:season][:end_date] = Date.strptime(params[:season][:end_date], "%m/%d/%Y")
    params[:season].delete(:wday)
    params[:season].delete('tee_time_start(5i)')


    respond_to do |format|
      if @season.update_attributes(params[:season])
        @season.handicapping_method.update_attributes(params[:handicapping_method])
        format.html { redirect_to @season, notice: 'Season was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @season.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /seasons/1
  # DELETE /seasons/1.json
  def destroy
    # @season = Season.find(params[:id])
    # @season.destroy

    respond_to do |format|
      format.html { redirect_to seasons_url }
      format.json { head :no_content }
    end
  end
end
