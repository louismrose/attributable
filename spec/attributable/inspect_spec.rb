require "attributable"

class User
  extend Attributable
  attributes :id, :forename, surname: "Bloggs"
end

describe Attributable do
  describe "inspect" do
    it "should emit type and attribute values" do
      i = User.new(id: 1, forename: "John", surname: "Doe")

      expect(i.inspect).to eq("<User id=1, forename=\"John\", surname=\"Doe\">")
    end
  end
end
