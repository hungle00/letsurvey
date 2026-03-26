# frozen_string_literal: true

require "rails_helper"

RSpec.describe Widget do
  describe "validations" do
    it "is valid with factory attributes" do
      expect(build(:widget)).to be_valid
    end

    it "is invalid without a title" do
      widget = build(:widget, title: nil)
      expect(widget).not_to be_valid
    end
  end
end
