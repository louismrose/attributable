require "attributable"

class User
  extend Attributable
  attributes :id, :forename, surname: "Bloggs"
end

class Patient
  extend Attributable
  attributes :id, :forename, surname: "Bloggs"
end

describe Attributable do
  describe "hash" do
    it "should ensure that objects with the same attribute values have the same hash" do
      i = User.new(id: 1, forename: "John", surname: "Doe")
      j = User.new(id: 1, forename: "John", surname: "Doe")

      expect(i.hash).to eq(j.hash)
    end

    it "should ensure that objects with different attribute values have different hashes" do
      a = User.new(id: 1, forename: "John", surname: "Doe")
      b = User.new(id: nil, forename: "John", surname: "Doe")
      c = User.new(id: 1, forename: nil, surname: "Doe")
      d = User.new(id: 1, forename: "John", surname: nil)

      hashes = [a, b, c, d].map(&:hash)

      expect(hashes.uniq).to eq(hashes)
    end

    it "should ensure that objects of different types different hashes" do
      u = User.new(id: 1, forename: "John", surname: "Doe")
      p = Patient.new(id: 1, forename: "John", surname: "Doe")

      expect(u.hash).not_to eq(p.hash)
    end
  end
end
