class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user, only: :destroy 
  before_action :useless_page, only: [:new, :create]

  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy 
      User.find(params[:id]).destroy unless current_user.admin? 
      flash[:success] = "User deleted." 
      redirect_to users_url
  end 
   
  def new
  	@user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)   
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit 
  end 

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user 
    else
      render 'edit'
    end
  end

   private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Before filters

    def signed_in_user #method that re-directs to sign-in page if user isn't signed in and going to disallowed page 
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in." #unless signed_in?
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    def useless_page #don't allow signed-in user to access new and create actions 
      redirect_to(root_url) unless !signed_in? 
    end

end
