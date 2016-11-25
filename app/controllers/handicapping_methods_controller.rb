class HandicappingMethodsController < ApplicationController
  # GET /handicapping_methods
  # GET /handicapping_methods.json
  def index
    @handicapping_methods = HandicappingMethod.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @handicapping_methods }
    end
  end

  # GET /handicapping_methods/1
  # GET /handicapping_methods/1.json
  def show
    @handicapping_method = HandicappingMethod.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @handicapping_method }
    end
  end

  # GET /handicapping_methods/new
  # GET /handicapping_methods/new.json
  def new
    @handicapping_method = HandicappingMethod.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @handicapping_method }
    end
  end

  # GET /handicapping_methods/1/edit
  def edit
    @handicapping_method = HandicappingMethod.find(params[:id])
  end

  # POST /handicapping_methods
  # POST /handicapping_methods.json
  def create
    @handicapping_method = HandicappingMethod.new(params[:handicapping_method])

    respond_to do |format|
      if @handicapping_method.save
        format.html { redirect_to @handicapping_method, notice: 'Handicapping method was successfully created.' }
        format.json { render json: @handicapping_method, status: :created, location: @handicapping_method }
      else
        format.html { render action: "new" }
        format.json { render json: @handicapping_method.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /handicapping_methods/1
  # PUT /handicapping_methods/1.json
  def update
    @handicapping_method = HandicappingMethod.find(params[:id])

    respond_to do |format|
      if @handicapping_method.update_attributes(params[:handicapping_method])
        format.html { redirect_to @handicapping_method, notice: 'Handicapping method was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @handicapping_method.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /handicapping_methods/1
  # DELETE /handicapping_methods/1.json
  def destroy
    # @handicapping_method = HandicappingMethod.find(params[:id])
    # @handicapping_method.destroy

    respond_to do |format|
      format.html { redirect_to handicapping_methods_url }
      format.json { head :no_content }
    end
  end
end
