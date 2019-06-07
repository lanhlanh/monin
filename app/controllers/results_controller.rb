class ResultsController < ApplicationController
  before_action :logged_in_user

  def index
    @range_time = RangeTime.last
    return redirect_to root_path unless @range_time
    @users = User.all
    @expenses = []
    @cost = []
    money = @range_time.money
    @users.all.each_with_index do |user, index|
      @cost[index] = money.joins(:money_user_crazies).where(money_user_crazies: {user_id: user.id}).sum(:amount_per_user)
      @expenses[index] = 0
      money.where(user_id: user.id).each { |money| @expenses[index] += money.amount_per_user * money.num_of_user }
    end

    @tongtien = money.sum(:amount_per_user)
  end
end
