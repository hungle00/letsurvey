# frozen_string_literal: true

require "rails_helper"

RSpec.describe User do
  describe "validations" do
    it "is valid with factory attributes" do
      expect(build(:user)).to be_valid
    end

    it "requires a password on create" do
      user = described_class.new(
        email_address: "new@example.com",
        password: nil,
        password_confirmation: nil
      )
      expect(user).not_to be_valid
      expect(user.errors[:password]).to be_present
    end

    it "rejects duplicate email_address at the database (unique index)" do
      create(:user, email_address: "taken@example.com")
      duplicate = build(:user, email_address: "taken@example.com")
      expect { duplicate.save! }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end

  describe "normalizations" do
    it "strips and downcases email_address" do
      user = build(:user, email_address: "  Person@EXAMPLE.com  ")
      user.valid?
      expect(user.email_address).to eq("person@example.com")
    end
  end

  describe "#has_active_subscription?" do
    it "returns false when there is no subscription" do
      user = create(:user)
      expect(user.has_active_subscription?).to be false
    end
  end
end
