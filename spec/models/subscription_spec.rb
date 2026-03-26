# frozen_string_literal: true

require "rails_helper"

RSpec.describe Subscription do
  describe "validations" do
    it "is valid with factory attributes" do
      expect(build(:subscription)).to be_valid
    end

    it "is invalid without a user" do
      subscription = build(:subscription, user: nil)
      expect(subscription).not_to be_valid
    end
  end

  describe "#is_in_trial?" do
    it "returns true if the subscription is in trial" do
      subscription = build(:subscription, trial_end_date: Date.current + 1.month)
      expect(subscription.is_in_trial?).to be true
    end
  end
end
