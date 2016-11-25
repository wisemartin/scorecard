class WeeksController < ApplicationController
  # GET /weeks
  # GET /weeks.json
  def index
    @weeks = Week.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @weeks }
    end
  end

  # GET /weeks/1
  # GET /weeks/1.json
  def show
    @week = Week.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @week }
    end
  end

  # GET /weeks/new
  # GET /weeks/new.json
  def new
    @week = Week.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @week }
    end
  end

  # GET /weeks/1/edit
  def edit
    @week = Week.find(params[:id])
  end

  # POST /weeks
  # POST /weeks.json
  def create
    @week = Week.new(params[:week])

    respond_to do |format|
      if @week.save
        format.html { redirect_to @week, notice: 'Week was successfully created.' }
        format.json { render json: @week, status: :created, location: @week }
      else
        format.html { render action: "new" }
        format.json { render json: @week.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /weeks/1
  # PUT /weeks/1.json
  def update
    @week = Week.find(params[:id])

    respond_to do |format|
      if @week.update_attributes(params[:week])
        format.html { redirect_to @week, notice: 'Week was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @week.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /weeks/1
  # DELETE /weeks/1.json
  def destroy
    # @week = Week.find(params[:id])
    # @week.destroy

    respond_to do |format|
      format.html { redirect_to weeks_url }
      format.json { head :no_content }
    end
  end
end
