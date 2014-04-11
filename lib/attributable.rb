require "attributable/version"

module Attributable
  def attributes(*without_defaults, **with_defaults)
    @attributes ||= {}
    @attributes.merge!(attributes_from(superclass)) if respond_to?(:superclass)
    @attributes.merge!(attributes_from(*included_modules))
    @attributes.merge!(from(without_defaults, with_defaults))
    add_instance_methods(@attributes)
  end

  private

  def attributes_from(*modules)
    modules
      .select { |m| m.kind_of?(Attributable) }
      .map { |m| m.instance_variable_get(:@attributes) }
      .reduce({}, &:merge)
  end

  # Converts a list of attribute names and a hash of attribute names to default values
  # to a hash of attribute names to default values
  def from(without_defaults, with_defaults)
    {}.tap do |attributes|
      without_defaults.each { |name| attributes[name] = nil }
      with_defaults.each_pair { |name, default| attributes[name] = default }
    end
  end

  def add_instance_methods(attributes)
    add_constructor(attributes)
    add_accessors(attributes.keys)
    add_equality_methods(attributes.keys)
    add_inspect_method(attributes.keys)
  end

  def add_constructor(attributes)
    define_method "initialize" do |values = {}|
      initialize_attributes(values)
    end

    define_method "initialize_attributes" do |values = {}|
      unknown_keys = values.keys - attributes.keys
      fail KeyError, "Unknown attributes: #{(unknown_keys).join(", ")}" unless unknown_keys.empty?

      @attributes = attributes.merge(values)
    end
  end

  def add_accessors(names)
    names.each do |name|
      define_method "#{name}" do
        @attributes[name.to_sym]
      end
    end
  end

  def add_equality_methods(names)
    define_method "eql?" do |other|
      other.is_a?(self.class) &&
      names.all? { |name| other.send(name.to_sym) == send(name.to_sym) }
    end

    alias_method "==", "eql?"

    define_method "hash" do
      self.class.hash + @attributes.hash
    end
  end

  def add_inspect_method(names)
    define_method "inspect" do
      values = @attributes.keys
        .map { |name| "#{name}=#{@attributes[name].inspect}" }
        .join(", ")

      "<#{self.class.name} #{values}>"
    end
  end
end
