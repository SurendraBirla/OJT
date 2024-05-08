class UsersController < ApplicationController
	before_action :authorize_request, except: :create
  before_action :find_user, except: %i[create index]
  before_action :authorize_admin, only: :status_approved

  def index
    # @users = User.all
    @users = User.all_except(@current_user) if is_admin?
    render json: @users, status: :ok
  end


  def show
    render json: @user, status: :ok
  end

 
  def create
    @user = User.new(user_params)
    if @user.save 
      UserMailer.with(user: @user).welcome_email.deliver_now unless is_admin?
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  
  def update
    unless @user.update(user_params)
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  
  def destroy
    @user.destroy
  end

  def status_approved
    @user.status = User::STATUS_APPROVED
    if @user.save
      # UserMailer.with(user: @user).approved_user_status.deliver_now unless is_admin?
      render json: @user, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def find_user
    @user = User.find_by_username!(params[:_username])
    rescue ActiveRecord::RecordNotFound
      render json: { errors: 'User not found' }, status: :not_found
  end

  def user_params
    permitted_params = [:name, :username, :email, :password, :password_confirmation]
    permitted_params << :status if is_admin? 
    params.permit(permitted_params)

    # params.permit(
    #    :name, :username, :email, :password, :password_confirmation, :status
    # )
  end
  

  def authorize_admin
    render json: { errors: 'Unauthorized' }, status: :unauthorized unless is_admin?
  end
end
