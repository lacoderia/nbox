class EmailsController < ApplicationController
  before_action :set_email, only: [:show, :update, :destroy]

  # GET /emails
  # GET /emails.json
  def index
    @emails = Email.all

    render json: @emails
  end

  # GET /emails/1
  # GET /emails/1.json
  def show
    render json: @email
  end

  # POST /emails
  # POST /emails.json
  def create
    @email = Email.new(email_params)

    if @email.save
      render json: @email, status: :created, location: @email
    else
      render json: @email.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /emails/1
  # PATCH/PUT /emails/1.json
  def update
    @email = Email.find(params[:id])

    if @email.update(email_params)
      head :no_content
    else
      render json: @email.errors, status: :unprocessable_entity
    end
  end

  # DELETE /emails/1
  # DELETE /emails/1.json
  def destroy
    @email.destroy

    head :no_content
  end

  private

    def set_email
      @email = Email.find(params[:id])
    end

    def email_params
      params.require(:email).permit(:user_id, :email_status, :email_type)
    end
end
