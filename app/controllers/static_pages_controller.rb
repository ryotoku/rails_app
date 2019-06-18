class StaticPagesController < ApplicationController
  include StaticPagesHelper
  def home
    Video.delete_all
    @video = Video.new
    get_data
#      @video = Video.page(params[:page])
    @videos = Video.all
  end

  def recommend
  end

  def popular
  end

end

