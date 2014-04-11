require "attributable"

class User
  extend Attributable
  attributes :id, :forename, surname: "Bloggs"
end

describe Attributable do
  describe "accessors" do
    it "should not have an accessor for an unknown attribute" do
      i = User.new(id: 1, forename: "John", surname: "Doe")
      expect(i.respond_to?(:address)).to be_false
    end

    it "should not have setters" do
      i = User.new(forename: "John")

      expect(i.respond_to?(:id=)).to be_false
    end
  end
end
