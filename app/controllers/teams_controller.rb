class TeamsController < ApplicationController
  helper 'application'
  layout 'season'
  # GET /teams
  # GET /teams.json

  def index
    session[:season_id]= params[:id] if params[:id]
    redirect_to organization_path unless session[:season_id].present?
    @season = Season.find(session[:season_id])

    @divisions = @season.divisions
    @teams = @season.divisions.collect{|div| div.teams}.flatten
    @weeks = @season.schedule.weeks.order(:date)
    @max_week = @weeks.last

    if params[:download]
      obj = render_to_string(:layout => true)
      File.open("c:\\holeinone\\teams.html","w") do |file|
         file.puts obj
      end
    end
    respond_to do |format|
      # render normally
      format.html # index.html.erb
      format.json { render json: @teams }
    end
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
    @team = Team.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @team }
    end
  end

  # GET /teams/new
  # GET /teams/new.json
  def new
    #@season = current_season
    @season ||= Season.find(session[:season_id])
    @team = Team.new(:division_id=>@season.divisions.first.id)
    players = []
    @season.roster_size.times do |a|
      players << Player.new()
    end
    @team.players=players
    @subs = (@team.season.players(:order=>'first_name') - @season.divisions.collect{|div| div.teams.collect{|team| team.players}}.flatten).map { |player| [player.full_name, player.id] }.sort_by { |a,b| a[0]<=>b[0]}
    @divisions = @season.divisions.map { |div| [div.name, div.id] }

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @team }
    end
  end

  # GET /teams/1/edit
  def edit
    Rails.cache.clear
    @team = Team.find(params[:id])
    @subs = (Player.sub_list+ @team.players).map { |player| [player.full_name, player.id] }
    @divisions = Division.all.map { |div| [div.name, div.id] }

  end

  # POST /teams
  # POST /teams.json
  def create
    players = params[:team][:players_attributes].values.collect{|p| Player.find(p.values.first)}
    params[:team].delete("players_attributes")
    @team = Team.new(params[:team])
    @team.players=players

    respond_to do |format|
      if params[:team] && @team.save
        format.html { redirect_to action: :index, notice: 'Team was successfully created.' }
        format.json { render json: @team, status: :created, location: @team }
      elsif params[:team].blank?
        format.html { redirect_to @team }

      else
        format.html { render action: "new" }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /teams/1
  # PUT /teams/1.json
  def update
    @team = Team.find(params[:id])

    respond_to do |format|
      if @team.update_attributes(params[:team])
        format.html { redirect_to @team, notice: 'Team was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    # @team = Team.find(params[:id])
    # @team.destroy

    respond_to do |format|
      format.html { redirect_to teams_url }
      format.json { head :no_content }
    end
  end
end
