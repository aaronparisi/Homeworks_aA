require 'byebug'
class AttrAccessorObject
  def self.my_attr_accessor(*names)
    # any instance of class AttrAccessorObject, or classes which inherit it,
    # will have my_attr_accessor available to it
    # so I can say myInheritingClass.my_attr_accessor(:someVariable)
    # i.e. self.my_attr..., i.e. my_attr_accessor, just like I would usually

    # this "macro" should define getter and setter methods for whichever
    # variables are given in the *names argument

    names.each do |name|
      define_method(name) do
        self.instance_variable_get("@#{name}")
      end

      define_method("#{name.to_s}=") do |setVal|
        self.instance_variable_set("@#{name}", setVal)
      end
    end
  end
end
