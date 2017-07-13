class InstructorsController < ApplicationController
  before_action :set_instructor, only: [:show]

  # GET /instructors
  # GET /instructors.json
  def index
    @instructors = Instructor.active

    render json: {instructors: @instructors}.to_json
  end

  # GET /instructors/1
  # GET /instructors/1.json
  def show
    render json: @instructor
  end

  private

    def set_instructor
      @instructor = Instructor.find(params[:id])
    end
end
