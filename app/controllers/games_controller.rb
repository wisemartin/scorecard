class GamesController < ApplicationController
  # GET /games
  # GET /games.json
  caches_action :index, :cache_path => Proc.new { |c| c.params }

  def index
    max_week = params[:week]||Game.first(:select => 'min(week) as week', :conditions => 'scores.id is null', :joins => 'left join scores on scores.game_id = games.id').week
    @max_week = Game.select('max(week) as week').limit(1).first.week
    @games = Game.all(:conditions => ["week = ?", max_week], :order => 'tee_time')
    @weeks_with_games = Game.select("distinct(week) as week").collect{|game| game.week}
    @skins = []
    @low_net_score = []
    if Score.by_week(max_week).limit(1).present?
      @skins = Game.skins(max_week)||[]
      @skin_count = Player.where(:skins_paid => true).count
      @low_net_score = Game.low_net_score(max_week).uniq[0..3]
    end
    @average_scores = Score.select('hole_id, round(avg(score),0) as score').joins('join games on games.id = scores.game_id').where("games.week = #{max_week}").group('hole_id')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @games }
    end
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @game = Game.find(params[:id])
    @matches = @game.player_matchups
    @scores = @game.scores
    @match_points = @matches.collect { |mp| @game.match_scores(mp.first, mp.last) }
    @net_points = @game.net_points


    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @game }
    end
  end

  # GET /games/new
  # GET /games/new.json
  def new
    @game = Game.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @game }
    end
  end

  # GET /games/1/edit
  def edit
    @game = Game.find(params[:id])
    @game.player_matchups
    @subs = Player.sub_list
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(params[:game])

    respond_to do |format|
      format.html { redirect_to @game, notice: 'Game was successfully created.' }
      format.json { render json: @game, status: :created, location: @game }
    end
  end

  # PUT /games/1
  # PUT /games/1.json
  def update
    @game = Game.find(params[:id])
    players = params.select { |key, value| key=~/player/i }
    player_vals = {}
    players.each { |key, value| player_vals[key]=value["id"] }
    @game.update_attributes(player_vals)

    @game.scores.destroy_all
    Rails.cache.clear

    players.each do |key, value|
      #"home_player_one_id"=>{"id"=>"10",
      # "scores"=>{"hole_1"=>"4",
      # "hole_2"=>"3",
      # "hole_3"=>"4",
      # "hole_4"=>"3",
      # "hole_5"=>"5",
      # "hole_6"=>"4",
      # "hole_7"=>"5",
      # "hole_8"=>"3",
      # "hole_9"=>"5"}}
      player = Player.find(value['id'])
      value['scores'].each do |key, value|
        player.scores.create!(:hole_id => key.split("_").last, :score => value, :game_id => @game.id)
      end
    end
    @game.reload
    @game.set_scores

    respond_to do |format|
      format.html { redirect_to @game, notice: 'Game was successfully updated.' }
      format.json { head :no_content }
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    # @game = Game.find(params[:id])
    # @game.destroy

    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { head :no_content }
    end
  end
end
