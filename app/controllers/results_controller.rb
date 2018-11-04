class ResultsController < ApplicationController
  before_action :logged_in_user

  def index
    @range_time = RangeTime.last
    return redirect_to root_path unless @range_time
    @users = User.all
    @money = @range_time.money
    @tongtien = @money.sum(:amount)
    @tien_tb = (@tongtien/@users.count).round()
  end
end
