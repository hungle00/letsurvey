class PageController < ApplicationController
  allow_unauthenticated_access only: %i[ welcome ]

  def welcome
    @plans = Plan.all
  end
end
