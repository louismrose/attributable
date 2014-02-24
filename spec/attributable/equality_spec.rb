require "attributable"

class User;    extend Attributable; attributes :id, :forename, surname: "Bloggs" end
class Patient; extend Attributable; attributes :id, :forename, surname: "Bloggs" end

describe Attributable do
  describe "equality" do
    it "should provide a working eql? method" do
      i = User.new(id: 1, forename: 'John', surname: 'Doe')
      j = User.new(id: 1, forename: 'John', surname: 'Doe')
    
      expect(i).to eql(j)
    end
    
    it "should provide a working == method" do
      i = User.new(id: 1, forename: 'John', surname: 'Doe')
      j = User.new(id: 1, forename: 'John', surname: 'Doe')
    
      expect(i).to be == j
    end
    
    it "should distinguish between objects with different attribute values" do
      i = User.new(id: 1, forename: 'John', surname: 'Doe')
      j = User.new(id: 1, forename: 'Jane', surname: 'Doe')
    
      expect(i).not_to eql(j)
      expect(i).not_to be == j
    end
    
    it "should distinguish between objects with different types and same attribute values" do
      i = User.new(id: 1, forename: 'John', surname: 'Doe')
      j = Patient.new(id: 1, forename: 'John', surname: 'Doe')
    
      expect(i).not_to eql(j)
      expect(i).not_to be == j
    end
  end
end
