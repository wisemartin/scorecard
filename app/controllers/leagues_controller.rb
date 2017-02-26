class LeaguesController < ApplicationController
  # GET /leagues
  # GET /leagues.json

  before_filter :require_auth, :only => [:new, :edit, :create]
  before_filter :set_session, :except => [:new, :create]

  def set_session
    unless params[:id]||session[:organization_id]||session[:league_id]
      respond_to do |format|
        format.html {redirect_to organizations_path, notice: 'You have to select an organization first.'}
      end
    else
      mu = League.find(params[:id]) if params[:id]
      mu ||= League.find(session[:league_id])
      if mu
        session[:league_id] = mu.id
        session[:organization_id] = mu.organization_id
      end
    end
  end

  def index
    @leagues = League.find_all_by_organization_id(session[:organization_id]) if session[:organization_id]
    @leagues ||= League.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @leagues }
    end
  end

  # GET /leagues/1
  # GET /leagues/1.json
  def show
    @league = League.find(session[:league_id])
    @seasons = @league.seasons
    render 'seasons/index'
    # respond_to do |format|
    #   format.html # show.html.erb
    #   format.json { render json: @league }
    # end
  end

  # GET /leagues/new
  # GET /leagues/new.json
  def new

    @league = League.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @league }
    end
  end

  # GET /leagues/1/edit
  def edit
    @league = League.find(params[:id])
  end

  # POST /leagues
  # POST /leagues.json
  def create
    @league = League.new(params[:league])
    @league.organization_id=session[:organization_id]

    respond_to do |format|
      if @league.save
        format.html { redirect_to @league, notice: 'League was successfully created.' }
        format.json { render json: @league, status: :created, location: @league }
      else
        format.html { render action: "new" }
        format.json { render json: @league.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /leagues/1
  # PUT /leagues/1.json
  def update
    @league = League.find(params[:id])

    respond_to do |format|
      if @league.update_attributes(params[:league])
        format.html { redirect_to @league, notice: 'League was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @league.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /leagues/1
  # DELETE /leagues/1.json
  def destroy
    @league = League.find(params[:id])
    @league.destroy

    respond_to do |format|
      format.html { redirect_to leagues_url }
      format.json { head :no_content }
    end
  end
end
