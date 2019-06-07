class RangeTimesController < ApplicationController
  before_action :logged_in_user

  def index
    @range_times = RangeTime.all.order(id: :desc)
  end

  def show
    @range_time = RangeTime.find_by id: params[:id]
    unless @range_time
      flash[:warning] = "Bye Bye! K có sổ này"
      redirect_to range_times_path
    end

    @users = User.all
    @money = @range_time.money
    @tongtien = @money.sum(:amount_per_user)

    @expenses = []
    @cost = []
    money = @range_time.money
    @users.all.each_with_index do |user, index|
      @cost[index] = money.joins(:money_user_crazies).where(money_user_crazies: {user_id: user.id}).sum(:amount_per_user)
      @expenses[index] = 0
      money.where(user_id: user.id).each { |money| @expenses[index] += money.amount_per_user * money.num_of_user }
    end
  end

  def update
    unless current_user.admin?
      flash[:warning] = "Bye bye"
      redirect_to root_path
    end
    @range_time = RangeTime.find_by id: params[:id]
    unless @range_time
      flash[:warning] = "Bye Bye! k chốt dc sổ"
      redirect_to range_times_path
    end
    if @range_time.update_attributes end_time: Date.current
      flash[:success] = "Chốt thành công"
      redirect_to range_time_path(@range_time)
    else
      flash[:warning] = "Bye Bye! k chốt dc sổ"
      redirect_to range_times_path
    end
  end
end
