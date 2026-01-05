class ProductsController < ApplicationController
  def index
    if Current.user.subscription.present?
      @products = Current.user.subscription.products.order(created_at: :desc)
    else
      @products = []
    end
  end
end
