class ScoringMethodsController < ApplicationController
  # GET /scoring_methods
  # GET /scoring_methods.json
  def index
    @scoring_methods = ScoringMethod.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @scoring_methods }
    end
  end

  # GET /scoring_methods/1
  # GET /scoring_methods/1.json
  def show
    @scoring_method = ScoringMethod.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @scoring_method }
    end
  end

  # GET /scoring_methods/new
  # GET /scoring_methods/new.json
  def new
    @scoring_method = ScoringMethod.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @scoring_method }
    end
  end

  # GET /scoring_methods/1/edit
  def edit
    @scoring_method = ScoringMethod.find(params[:id])
  end

  # POST /scoring_methods
  # POST /scoring_methods.json
  def create
    @scoring_method = ScoringMethod.new(params[:scoring_method])

    respond_to do |format|
      if @scoring_method.save
        format.html { redirect_to @scoring_method, notice: 'Scoring method was successfully created.' }
        format.json { render json: @scoring_method, status: :created, location: @scoring_method }
      else
        format.html { render action: "new" }
        format.json { render json: @scoring_method.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /scoring_methods/1
  # PUT /scoring_methods/1.json
  def update
    @scoring_method = ScoringMethod.find(params[:id])

    respond_to do |format|
      if @scoring_method.update_attributes(params[:scoring_method])
        format.html { redirect_to @scoring_method, notice: 'Scoring method was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @scoring_method.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scoring_methods/1
  # DELETE /scoring_methods/1.json
  def destroy
    # @scoring_method = ScoringMethod.find(params[:id])
    # @scoring_method.destroy

    respond_to do |format|
      format.html { redirect_to scoring_methods_url }
      format.json { head :no_content }
    end
  end
end
