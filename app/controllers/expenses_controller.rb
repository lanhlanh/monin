class ExpensesController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user, only: %i(edit update destroy)

  def index
    last_time = RangeTime.last
    @expenses = last_time ? last_time.money.order(id: :desc) : []
  end

  def new
    @expense = @expense || current_user.money.build
  end

  def create
    user_ids = user_ids_allow
    num_of_user = user_ids.count

    amount_per_user = expense_params[:amount_per_user].to_f/num_of_user.to_f if num_of_user > 0

    @expense = current_user.money.build expense_params.merge(type_of_money: :expense, num_of_user: num_of_user, amount_per_user: amount_per_user, create_at: Time.current)

    if num_of_user > 0 && @expense.valid?
      ActiveRecord::Base.transaction do
        @expense.save
        @money_user_crazies = user_ids.each_with_index { |user_id, index| @expense.money_user_crazies.create!(money_id: @expense.id, user_id: user_id.to_i) }
        flash[:success]  = "Thêm thành công"
        redirect_to root_path
      end
    else
      flash[:warning] = "Thêm thất bạt"
      render :new
    end
  end

  def edit
    @expense = Money.find_by id: params[:id]
  end

  def update
    @expense = Money.find_by id: params[:id]
    amount_per_user = expense_params[:amount_per_user].to_f/@expense.num_of_user.to_f
    if @expense.update_attributes expense_params.merge(amount_per_user: amount_per_user)
      flash[:success]  = "Update thành công"
    else
      flash[:warning] = "Update thất bạt"
    end
    redirect_to expenses_path
  end


  def destroy
    @expense = Money.find_by id: params[:id]
    if @expense.destroy
      flash[:success]  = "Xóa thành công"
    else
      flash[:warning] = "Xóa thất bạt"
    end
    redirect_to root_url
  end

  private

  def expense_params
    params.require(:money).permit(:description, :amount_per_user, money_user_crazies_attributes: [:money_id, :user_id])
  end

  def admin_user
    unless current_user.admin?
      flash[:danger] = "Không được phép truy cập"
      redirect_to root_url
    end
  end

  def user_ids_allow
    user_ids = []
    ids = params[:user_ids].split(" ").to_a if params[:user_ids]
    ids.each_with_index { |id| user_ids << id.to_i if(User.find_by(id: id.to_i)) }
    user_ids
  end
end
