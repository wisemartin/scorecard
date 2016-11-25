class SchedulesController < ApplicationController
  # GET /schedules
  # GET /schedules.json
  layout 'season'

  before_filter :require_auth, :only => [:new, :edit, :create]
  before_filter :set_session, :except => [:new, :create]

  def set_session
    mu = Schedule.find(params[:id]).season if params[:id]
    mu ||= Season.find(session[:season_id])
    if mu
      session[:season_id] = mu.id
      session[:league_id] = mu.league_id
      session[:organization_id] = mu.league.organization_id
    end
  end


  def index
    @schedules = Schedule.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @schedules }
    end
  end

  # GET /schedules/1
  # GET /schedules/1.json
  def show
    @schedule = Schedule.find(params[:id])
    @week = Week.find(params[:week_id]) if params[:week_id]
    @week ||= @schedule.weeks.active_week.first
    @week ||= @schedule.weeks.order(:date).first
    @gross_skins = @week.gross_skins.collect do |sc|
      [sc.player.full_name, sc.hole.number, sc.score,
       case sc.hole.par - sc.score
         when 1
           'Birdie'
         when 2
           'Eagle'
         else
           'Par'
       end
      ]
    end if @schedule.season.gross_skins?

    @net_skins = @week.net_skins.collect do |sc|
      [sc.player.full_name, sc.hole.number, sc.net_score,
       case sc.hole.par - sc.net_score
         when 1
           'Birdie'
         when 2
           'Eagle'
         else
           'Albatross'
       end
      ]
    end if @schedule.season.net_skins?

    @net_scores = @week.rounds.where('gross_score > 0').order('rounds.gross_score-round(rounds.handicap), rounds.gross_score desc').limit(3).collect do |round|
      [round.player.full_name, round.gross_score, round.net_score]
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @schedule }
    end
  end

  # GET /schedules/new
  # GET /schedules/new.json
  def new
    @schedule = Schedule.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @schedule }
    end
  end

  # GET /schedules/1/edit
  def edit
    @schedule = Schedule.find(params[:id])
  end

  # POST /schedules
  # POST /schedules.json
  def create
    @schedule = Schedule.new(params[:schedule])

    respond_to do |format|
      if @schedule.save
        format.html { redirect_to @schedule, notice: 'Schedule was successfully created.' }
        format.json { render json: @schedule, status: :created, location: @schedule }
      else
        format.html { render action: "new" }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /schedules/1
  # PUT /schedules/1.json
  def update
    @schedule = Schedule.find(params[:id])

    respond_to do |format|
      if @schedule.update_attributes(params[:schedule])
        format.html { redirect_to @schedule, notice: 'Schedule was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /schedules/1
  # DELETE /schedules/1.json
  def destroy
    # @schedule = Schedule.find(params[:id])
    # @schedule.destroy

    respond_to do |format|
      format.html { redirect_to schedules_url }
      format.json { head :no_content }
    end
  end
end
