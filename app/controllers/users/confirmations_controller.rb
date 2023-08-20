# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  # def create
  #   super
  # end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show

    # Weird bug where the confirmation link goes to user/confirm instead of user/sign-up
    # so we have a redirect to it here if the user is already confirmed.
    resource = resource_class.confirm_by_token(params[:confirmation_token])
    if resource.confirmed?
      flash[:notice] = "Your email address has been successfully confirmed."
      redirect_to new_user_session_path
    else
      super
    end

  end

  protected

  # The path used after resending confirmation instructions.
  def after_resending_confirmation_instructions_path_for(resource_name)
    root_path
    # super(resource_name)
  end

  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    root_path
    # super(resource_name, resource)
  end
end
