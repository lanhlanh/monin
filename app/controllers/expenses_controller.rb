class ExpensesController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user, only: %i(edit update destroy)

  def index
    last_time = RangeTime.last
    @expenses = last_time ? last_time.money.order(id: :desc) : []
  end

  def new
    @expense = current_user.money.build
  end

  def create
    @expense = current_user.money.build expense_params.merge(type_of_money: :expense, create_at: Time.current)

    if @expense.save
      flash[:success]  = "Thêm thành công"
      redirect_to root_path
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
    if @expense.update_attributes expense_params
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
    params.require(:money).permit %i(description amount)
  end

  def admin_user
    unless current_user.admin?
      flash[:danger] = "Không được phép truy cập"
      redirect_to root_url
    end
  end
end
