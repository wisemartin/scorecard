class PlayersController < ApplicationController
  # GET /players
  # GET /players.json
  layout 'season'

  def index
    @season = Season.find(session[:season_id])
    @players = @season.divisions.collect { |d| d.teams }.flatten.collect { |t| t.players }.flatten
    @subs = @season.players - @players
    @weeks = @season.schedule.weeks.order(:date)
    if params[:download]
      obj = render_to_string(:layout => true)
      File.open("c:\\holeinone\\players.html", "w") do |file|
        file.puts obj
      end
      get_player_cards
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @players }
    end
  end

  # GET /players/1
  # GET /players/1.json
  def show
    @player = Player.find(params[:id])
    @usga_scores = @player.usga_scores.sort_by { |sc| sc.score }
    @usga_score_count = @player.usga_scores_to_use(@usga_scores.collect { |sc| sc.score }.size)
    @gms = ([0] << @player.unopposed_games).flatten.compact
    @player.scores.excluding_games(@gms).week_ending(1000000).last_few(4)

    @pearson_scores = @player.scores.all_by_week.last_few(4+(@gms.size-1))

    respond_to do |format|
      format.xml { render :xml => {:usga_scores => @usga_scores, :gms => @gms, :player => @player, :all_scores => @player.scores.all_by_week, :pearson_scores => @pearson_scores}, :root => 'player-card', :skip_types => true }
      format.html # show.html.erb
      format.json { render json: @player }
    end
  end

  # GET /players/new
  # GET /players/new.json
  def new
    if params[:copy_players].present?
      @season = Season.find(session[:season_id])
      @season.copy_players=true
      @season.add_players
      respond_to do |format|
        format.html {redirect_to players_path}
      end
    else
      @player = Player.new
      @season = Season.find(session[:season_id])

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @player }
      end
    end

  end

  # GET /players/1/edit
  def edit
    @player = Player.find(params[:id])
  end

  # POST /players
  # POST /players.json
  def create
    good_vals = params[:player].select { |key, value| value.present? }
    @player = Player.new(good_vals)


    respond_to do |format|
      if @player.save
        PlayersSeason.create(season_id: session[:season_id], player_id: @player.id)
        format.html { redirect_to players_path, notice: 'Player was successfully created.' }
        format.json { render json: @player, status: :created, location: @player }
      else
        format.html { render action: "new" }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /players/1
  # PUT /players/1.json
  def update
    @player = Player.find(params[:id])

    respond_to do |format|
      if @player.update_attributes(params[:player])
        format.html { redirect_to @player, notice: 'Player was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  def get_player_cards
    Player.all do |player|
      urlf = 'http://localhost:3000/players/' << player.id << '.xml'
      logger.info urlf
      url = URI.parse(urlf)
      logger.info url.inspect
      request = Net::HTTP.get_print(url)
      logger.info(request)
      File.open("c:\\holeinone\\players\\#{player.id}.xml", "w") { |file| file.puts(request) }
    end


  end

  # DELETE /players/1
  # DELETE /players/1.json
  def destroy
    # @player = Player.find(params[:id])
    # @player.destroy

    respond_to do |format|
      format.html { redirect_to players_url }
      format.json { head :no_content }
    end
  end
end
