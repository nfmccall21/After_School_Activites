# app/controllers/users/registrations_controller.rb
# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :html, :json

  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    build_resource(sign_up_params)
    Rails.logger.debug "Sign up params: #{sign_up_params.inspect}"
    Rails.logger.debug "Resource valid? #{resource.valid?}"
    Rails.logger.debug "Resource errors: #{resource.errors.full_messages.join(', ')}" unless resource.valid?
    if resource.save
      Rails.logger.debug "User saved successfully: #{resource.inspect}"
    else
      Rails.logger.debug "User save failed: #{resource.errors.full_messages.join(', ')}"
    end
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      Rails.logger.debug "Rendering new template due to validation errors"
      respond_with resource
    end
  end

  # GET /resource/edit
  def edit
    super
  end

  # PUT /resource
  def update
    super
  end

  # DELETE /resource
  def destroy
    super
  end

  # GET /resource/cancel
  #def cancel
  #  super
  #end

  protected

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    new_user_session_path(resource) # Redirect to the default after sign-in path
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    new_user_session_path
  end
end
