class ScoresController < ApplicationController
  respond_to :html, :js
  # GET /scores
  # GET /scores.json
  def index
    @scores = Score.where(:player_id => 1)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @scores }
    end
  end

  # GET /scores/1
  # GET /scores/1.json
  def show
    @score = Score.where(:game_id => params[:game_id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @score }
    end
  end

  # GET /scores/new
  # GET /scores/new.json
  def new
    @score = Score.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @score }
    end
  end

  # GET /scores/1/edit
  def edit
    @score = Score.find(params[:id])
  end

  # POST /scores
  # POST /scores.json
  def create
    @score = Score.find(params[:id])
    @score.update_attribute(:score, params[:score])
    respond_to do |format|
          format.html { redirect_to scores_url }
          format.json { head :no_content }
        end

  end

  # PUT /scores/1
  # PUT /scores/1.json
  def update
    @score = Score.find(params[:id])


  end

  # DELETE /scores/1
  # DELETE /scores/1.json
  def destroy
    # @score = Score.find(params[:id])
    # @score.destroy

    respond_to do |format|
      format.html { redirect_to scores_url }
      format.json { head :no_content }
    end
  end
end
