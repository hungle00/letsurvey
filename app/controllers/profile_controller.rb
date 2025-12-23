class ProfileController < ApplicationController
  before_action :set_user, only: [ :show, :edit, :update ]

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to profile_path, notice: "Profile updated successfully!"
    else
      render :edit, status: :unprocessable_entity, alert: "Failed to update profile: #{@user.errors.full_messages.join(', ')}"
    end
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :phone_number)
  end

  def set_user
    @user = Current.user
  end
end
