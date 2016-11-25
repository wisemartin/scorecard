class CoursesController < ApplicationController

  before_filter :require_auth, :only=>[:new, :edit, :create]
  def new
  end

  def show
  end

  def create
  end

  def update
  end

  def edit
  end

  def list
    @courses = Course.all
  end
  def add_tee_box
    course = Course.find(params[:id])
    @tee_box = course.tee_boxes.new(:holes=>(1..18).collect{|hole| Hole.new(:hole_number=>hole)})
  end
end
