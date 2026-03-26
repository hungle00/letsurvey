# frozen_string_literal: true

require "rails_helper"

RSpec.describe "WidgetsController", type: :request do
  describe "GET /widgets" do
    it "returns current user's widgets ordered by created_at desc" do
      user = create(:user)
      other_user = create(:user)

      newer_widget = create(
        :widget,
        user: user,
        title: "Newer Widget",
        created_at: 1.day.ago
      )
      older_widget = create(
        :widget,
        user: user,
        title: "Older Widget",
        created_at: 2.days.ago
      )
      create(:widget, user: other_user, title: "Other User Widget")

      sign_in_as(user)

      get widgets_path

      expect(response).to have_http_status(:ok)

      expect(response.body).to include(newer_widget.title)
      expect(response.body).to include(older_widget.title)
      expect(response.body).not_to include("Other User Widget")

      expect(response.body.index(newer_widget.title)).to be < response.body.index(older_widget.title)
    end
  end

  describe "GET /widgets/:id" do
    it "returns the widget" do
      user = create(:user)
      widget = create(:widget, user: user)

      session = Session.create!(user: user, ip_address: "127.0.0.1", user_agent: "RSpec")
      allow(Current).to receive(:session).and_return(session)
      allow(Current).to receive(:user).and_return(user)

      get widget_path(widget)

      expect(response).to have_http_status(:ok)

      expect(response.body).to include(widget.title)
    end
  end
end
