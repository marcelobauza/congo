class CountiesController < ApplicationController
  before_action :set_county, only: [:show, :edit, :update, :destroy]

    def index

    respond_to do |format|
      format.js 
    end
    end

  def find
    @id = params[:search][:name]
    @county = County.where(id: @id)
    respond_to do |format|
      format.js 
    end
  end
end
