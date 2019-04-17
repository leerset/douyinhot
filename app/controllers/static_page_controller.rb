class StaticPageController < ApplicationController
  skip_before_action :authenticate_user!
  def home
  end
  def api_doc
  end
end
