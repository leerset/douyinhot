class VideosController < ApplicationController
  before_action :authenticate_user!

  # GET /videos.
  def index
    @videos = Video.all
  end

  private

end
