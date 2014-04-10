require "attributable"

class User
  extend Attributable
  attributes :id, :forename, surname: "Bloggs"
end

class UserWithDerivedAttribute
  extend Attributable
  attributes :id, :forename, surname: "Bloggs"
  attr_reader :fullname

  def initialize(attributes = {})
    initialize_attributes(attributes)
    @fullname = "#{forename} #{surname}"
  end
end

describe Attributable do
  describe "construction" do
    it "should accept a hash" do
      i = User.new(id: 1, forename: "John", surname: "Doe")

      expect(i.id).to eq(1)
      expect(i.forename).to eq("John")
      expect(i.surname).to eq("Doe")
    end

    it "should set missing attributes to default" do
      i = User.new(forename: "John")

      expect(i.id).to be_nil
      expect(i.forename).to eq("John")
      expect(i.surname).to eq("Bloggs")
    end

    it "should set missing attributes without defaults to nil" do
      i = User.new(surname: "Doe")

      expect(i.id).to be_nil
      expect(i.forename).to be_nil
      expect(i.surname).to eq("Doe")
    end
  end

  describe "constructor" do
    it "should be overridable" do
      i = UserWithDerivedAttribute.new(id: 1, forename: "John", surname: "Doe")

      expect(i.id).to eq(1)
      expect(i.forename).to eq("John")
      expect(i.surname).to eq("Doe")
      expect(i.fullname).to eq("John Doe")
    end
  end
end
