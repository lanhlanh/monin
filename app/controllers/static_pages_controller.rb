class StaticPagesController < ApplicationController
  def home
    return unless logged_in?
  end

  def about; end

  def help; end

  def contact; end
end
