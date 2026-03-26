require "rails_helper"

RSpec.describe "ProfileController", type: :request do
  describe "GET /profile" do
    it "returns the profile" do
      user = create(:user)
      sign_in_as(user)
      get profile_path

      expect(response).to have_http_status(:ok)

      expect(response.body).to include(user.full_name)
    end
  end
end
