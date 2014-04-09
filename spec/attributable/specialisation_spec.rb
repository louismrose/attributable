require "attributable"

class User
  extend Attributable
  attributes :id, :forename, surname: "Bloggs"
end

describe Attributable do
  describe "specialisation" do
    it "should pull in attributes from specified class" do
      class SuperUser
        extend Attributable

        attributes :password, active: true
        specialises User
      end

      s = SuperUser.new(id: 1, forename: "Bob", password: "secret", active: false)

      expect(s.id).to eq(1)
      expect(s.forename).to eq("Bob")
      expect(s.surname).to eq("Bloggs")
      expect(s.password).to eq("secret")
      expect(s.active).to be_false
    end

    it "should be possible to declare specialisation before attributes" do
      class SuperUser2
        extend Attributable

        specialises User
        attributes :password, active: true
      end

      s = SuperUser2.new(id: 1, forename: "Bob", password: "secret", active: false)

      expect(s.id).to eq(1)
      expect(s.forename).to eq("Bob")
      expect(s.surname).to eq("Bloggs")
      expect(s.password).to eq("secret")
      expect(s.active).to be_false
    end

    it "should ensure that local attributes precede specialised attributes" do
      class SuperUser3
        extend Attributable

        specialises User
        attributes surname: "Smith"
      end

      s = SuperUser3.new

      expect(s.surname).to eq("Smith")
    end

    it "should ensure that position of specialises does not affect precedence" do
      class SuperUser4
        extend Attributable

        attributes surname: "Smith"
        specialises User
      end

      s = SuperUser4.new

      expect(s.surname).to eq("Smith")
    end

    it "should raise if specialising class is not an instance of Attributable" do
      expect do
        class SuperUser5
          extend Attributable
          specialises String
        end
      end.to raise_error(
        ArgumentError,
        "specialisation requires a class that extends Attributable"
      )
    end
  end
end
