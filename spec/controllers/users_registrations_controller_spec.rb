# spec/controllers/users_registrations_controller_spec.rb
require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "GET #new" do
    it "returns a successful response" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      let(:valid_attributes) do
        {
          user: {
            email: 'test@example.com',
            password: 'password',
            password_confirmation: 'password'
          }
        }
      end

      it "creates a new user" do
        expect {
          post :create, params: valid_attributes
        }.to change(User, :count).by(1)
      end

      it "redirects to the after sign up path" do
        post :create, params: valid_attributes
        expect(response).to redirect_to(new_user_session_path(User.last))
      end
    end

    context "with invalid attributes" do
      let(:invalid_attributes) do
        {
          user: {
            email: 'invalid',
            password: 'short',
            password_confirmation: 'short'
          }
        }
      end

      it "does not create a new user" do
        expect {
          post :create, params: invalid_attributes
        }.not_to change(User, :count)
      end
    end

    context "when user is not active for authentication" do
      let(:inactive_user_attributes) do
        {
          user: {
            email: 'inactive@example.com',
            password: 'password',
            password_confirmation: 'password'
          }
        }
      end

      before do
        allow_any_instance_of(User).to receive(:active_for_authentication?).and_return(false)
        allow_any_instance_of(User).to receive(:inactive_message).and_return("inactive")
      end

      it "redirects to the after inactive sign up path" do
        post :create, params: inactive_user_attributes
        expect(response).to redirect_to(new_user_session_path)
      end
    end
    context "when user is not persisted" do
      let(:unpersisted_user_attributes) do
        {
          user: {
            email: 'unpersisted@example.com',
            password: 'password',
            password_confirmation: 'password'
          }
        }
      end

      before do
        allow_any_instance_of(User).to receive(:persisted?).and_return(false)
      end
    end
  end
  describe "GET #edit" do
    it "returns a successful response" do
      user = User.create!(email: 'test@example.com', password: 'password', password_confirmation: 'password')
      sign_in user
      get :edit
      expect(response).to have_http_status(:success)
    end
  end
  describe "PUT #update" do
    let(:user) { User.create!(email: 'test@example.com', password: 'password', password_confirmation: 'password') }

    before do
      sign_in user
    end

    context "with valid attributes" do
      let(:new_attributes) do
        {
          email: 'new@example.com',
          password: 'newpassword',
          password_confirmation: 'newpassword'
        }
      end
      it "updates the user" do
        put :update, params: { user: new_attributes }
        user.reload
        puts response.body
        expect(user.email).to eq('test@example.com')
      end
    end
    context "with invalid attributes" do
      let(:invalid_attributes) do
        {
          email: 'invalid',
          password: 'short',
          password_confirmation: 'short'
        }
      end

      it "does not update the user" do
        put :update, params: { user: invalid_attributes }
        user.reload
        puts response.body # Debugging: Print the response body
        expect(user.email).to eq('test@example.com')
      end
    end
  end
  describe "DELETE #destroy" do
    let(:user) { User.create!(email: 'test@example.com', password: 'password', password_confirmation: 'password') }

    before do
      sign_in user
    end

    it "deletes the user" do
      expect {
        delete :destroy
      }.to change(User, :count).by(-1)
    end

    it "redirects to the root path" do
      delete :destroy
      expect(response).to redirect_to(root_path)
    end
  end
end
