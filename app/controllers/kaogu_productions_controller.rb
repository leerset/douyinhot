class KaoguProductionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @kaogu_productions = KaoguProduction.where.not(rank: nil)
  end

  private
end
