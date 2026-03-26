# frozen_string_literal: true

module AuthHelpers
  # Stub Authentication#resume_session / Current.user for request specs.
  # This avoids dealing with signed cookies in controller/request tests.
  def sign_in_as(user)
    session = Session.create!(
      user: user,
      ip_address: "127.0.0.1",
      user_agent: "RSpec"
    )

    allow(Current).to receive(:session).and_return(session)
    allow(Current).to receive(:user).and_return(user)

    session
  end
end

RSpec.configure do |config|
  config.include AuthHelpers, type: :request
end

