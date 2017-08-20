require 'rails_helper'
require 'database_cleaner'
require 'byebug'
DatabaseCleaner.strategy = :truncation

RSpec.describe WelcomeController, type: :controller do
  let(:teacher) {FactoryGirl.create(:teacher)}
  let(:valid_session) {{user_id: teacher.id}}

  describe "GET #index" do
    it "redirects to login page if user is not logged in" do
      get :index
      expect(response).to redirect_to login_url
    end

    it "redirects user if they are logged in and get to the welcome index" do
      get :index, {}, valid_session
      expect(response.redirect?).to be true
    end
  end

  after(:each) do 
    DatabaseCleaner.clean
  end
end
