class WeeksController < ApplicationController
  helper 'application'
  layout 'season'
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
    @schedule = @week.schedule
    @matchups = ([] << @week.matchups).flatten
    @matchups ||= []

    (((@week.season.number_playing_each_match/2)*(@week.season.teams.count.to_f/2)).round-@matchups.count).times do |mu|
      @matchups << Matchup.new(week: @week)
    end
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

  # "schedule_week"=>"position_night",    = KEY for position night.
  # "schedule_week"=>"round_robin",  = KEY for round robin
  # "schedule_week"=>"cross_division_matchups", = KEY for cross-division random matchups.
  # "schedule_week"=>"random_divisional_matchups", = inter divisional matchups, random (basically just choose one random week from a round robin schedule)

  def update
    @week = Week.find(params[:id])

    case params[:schedule_week]

      when 'practice_round'
        raise 'see!'
        #empty week, adding an automated_schedule.
      when 'round_robin'

        @week.season.divisions.each do |division|
          division.round_robin_schedule(nil, @week, params[:round_robin_all_teams].to_s=='on', params[:round_robin_schedule].to_s=='extend',nil ,params[:round_robin_overwrite].to_s=='on')
          break if params[:round_robin_all_teams]=='on'
        end

      when 'position_night'
        raise 'see!'

      when 'cross_division_matchups'
        raise 'see!'


      when 'random_divisional_matchups'
        raise 'see!'


      when 'manual_update'
        raise 'see!'
        #changing tee times or matchups of an existing new week. OR creating new matchups and tee-times!
        params[:week][:matchups_attributes].each_pair do |key, value|
          value.parse_time_select! :tee_time
        end
      when 'rain_out'
        last_week = @week.schedule.weeks.where(["weeks.date > ? ",@week.date]).order("date asc").select{|wk| wk.matchups.blank?}.first
        last_week ||= @week.schedule.weeks.create(:date=>@week.date)
        case params[:rainout_option]
          when 'move'
            last_week.update_attribute(:matchups, @week.matchups)
            last_week.save!
          when 'slide'
            dte = @week.date
            @week.schedule.weeks.where(["weeks.date >= ? ",@week.date]).each{|week| week.update_attribute(:date,week.date+7.days)}
            last_week.update_attribute(:date,dte)
          when 'discard'
            @week.matchups.destroy_all
        end
      else
        raise 'see!'


    end
    respond_to do |format|
      format.html { redirect_to schedule_path(@week.schedule) << "?week_id=#{@week.id}", notice: 'Week was successfully updated.' }
      format.json { head :no_content }
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
