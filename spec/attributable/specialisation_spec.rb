require "attributable"

describe Attributable do
  describe "prerequisites for specialisation" do
    it "should be possible to call attributes more than once" do
      class Person
        extend Attributable
        attributes :forename, surname: "Bloggs"
        attributes :id, active: true
      end

      p = Person.new(id: 1, forename: "Bob")

      expect(p.id).to eq(1)
      expect(p.forename).to eq("Bob")
      expect(p.surname).to eq("Bloggs")
      expect(p.active).to be_truthy
    end
  end

  describe "inheritance" do
    class User
      extend Attributable
      attributes :id, :forename, surname: "Bloggs"
    end

    it "should inherit attributes from superclass" do
      class SuperUser < User
        attributes :password, active: true
      end

      s = SuperUser.new(id: 1, forename: "Bob", password: "secret", active: false)

      expect(s.id).to eq(1)
      expect(s.forename).to eq("Bob")
      expect(s.surname).to eq("Bloggs")
      expect(s.password).to eq("secret")
      expect(s.active).to be_falsey
    end

    it "should ensure that subclass's attributes precede superclass's" do
      class SuperUser2 < User
        attributes surname: "Smith"
      end

      s = SuperUser2.new

      expect(s.surname).to eq("Smith")
    end
  end

  describe "mixins" do
    module Author
      extend Attributable
      attributes articles: []
    end

    it "should inherit attributes from mixed-in module" do
      class Columnist
        include Author

        extend Attributable
        attributes :column
      end

      c = Columnist.new(column: "Agony Aunt", articles: [:teen_advice])

      expect(c.column).to eq("Agony Aunt")
      expect(c.articles).to eq([:teen_advice])
    end

    it "should inherit defaults from mixed-in module" do
      class Columnist2
        include Author

        extend Attributable
        attributes :column
      end

      c = Columnist2.new

      expect(c.articles).to eq([])
    end

    it "should ensure that includee's attributes precede included's" do
      class Columnist3
        include Author

        extend Attributable
        attributes articles: [:daily_column]
      end

      c = Columnist3.new

      expect(c.articles).to eq([:daily_column])
    end

    xit "should work when include is last" do
      class Columnist4
        extend Attributable
        attributes :column
        include Author
      end

      c = Columnist4.new(column: "Agony Aunt", articles: [:teen_advice])

      expect(c.articles).to eq([:teen_advice])
      expect(c).to eq(Columnist4.new(column: "Agony Aunt", articles: [:teen_advice]))
    end

    it "should work when include is in the middle" do
      class Columnist5
        extend Attributable
        include Author
        attributes :column
      end

      c = Columnist5.new(column: "Agony Aunt", articles: [:teen_advice])

      expect(c.articles).to eq([:teen_advice])
      expect(c).to eq(Columnist5.new(column: "Agony Aunt", articles: [:teen_advice]))
    end

    it "should work with several includes" do
      module Editor
        extend Attributable
        attributes :section
      end

      class AuthorAndEditor
        include Author, Editor
        extend Attributable
        attributes :name
      end

      ae = AuthorAndEditor.new(name: "Joe Bloggs", section: "Sport")

      expect(ae.name).to eq("Joe Bloggs")
      expect(ae.section).to eq("Sport")
      expect(ae.articles).to eq([])
    end
  end

  describe "inheritance and mixins" do
    class Blogger < User
      include Author
      extend Attributable
      attributes :blog_name
    end

    it "should inherit attributes from both" do
      b = Blogger.new(
        id: 1,
        forename: "John",
        surname: "Doe",
        articles: [:daily_column],
        blog_name: "Research Rants"
      )

      expect(b.id).to eq(1)
      expect(b.forename).to eq("John")
      expect(b.surname).to eq("Doe")
      expect(b.articles).to eq([:daily_column])
      expect(b.blog_name).to eq("Research Rants")
    end

    it "should inherit defaults from both" do
      b = Blogger.new

      expect(b.surname).to eq("Bloggs")
      expect(b.articles).to eq([])
    end
  end
end
