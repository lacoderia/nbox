class PacksController < ApplicationController

  # GET /packs
  # GET /packs.json
  def index
    @packs = Pack.where(active: true)

    render json: @packs
  end
end
