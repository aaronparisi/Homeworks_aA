require 'byebug'

class SnackBox
  SNACK_BOX_DATA = {
    1 => {
      "bone" => {
        "info" => "Phoenician rawhide",
        "tastiness" => 20
      },
      "kibble" => {
        "info" => "Delicately braised hamhocks",
        "tastiness" => 33
      },
      "treat" => {
        "info" => "Chewy dental sticks",
        "tastiness" => 40
      }
    },
    2 => {
      "bone" => {
        "info" => "An old dirty bone",
        "tastiness" => 2
      },
      "kibble" => {
        "info" => "Kale clusters",
        "tastiness" => 1
      },
      "treat" => {
        "info" => "Bacon",
        "tastiness" => 80
      }
    },
    3 => {
      "bone" => {
        "info" => "A steak bone",
        "tastiness" => 64
      },
      "kibble" => {
        "info" => "Sweet Potato nibbles",
        "tastiness" => 45
      },
      "treat" => {
        "info" => "Chicken bits",
        "tastiness" => 75
      }
    }
  }
  def initialize(data = SNACK_BOX_DATA)
    @data = data
  end

  def get_bone_info(box_id)
    @data[box_id]["bone"]["info"]
  end

  def get_bone_tastiness(box_id)
    @data[box_id]["bone"]["tastiness"]
  end

  def get_kibble_info(box_id)
    @data[box_id]["kibble"]["info"]
  end

  def get_kibble_tastiness(box_id)
    @data[box_id]["kibble"]["tastiness"]
  end

  def get_treat_info(box_id)
    @data[box_id]["treat"]["info"]
  end

  def get_treat_tastiness(box_id)
    @data[box_id]["treat"]["tastiness"]
  end
end

class CorgiSnacks

  def initialize(snack_box, box_id)
    @snack_box = snack_box
    @box_id = box_id
  end

  def bone
    info = @snack_box.get_bone_info(@box_id)
    tastiness = @snack_box.get_bone_tastiness(@box_id)
    result = "Bone: #{info}: #{tastiness} "
    tastiness > 30 ? "* #{result}" : result
  end

  def kibble
    info = @snack_box.get_kibble_info(@box_id)
    tastiness = @snack_box.get_kibble_tastiness(@box_id)
    result = "Kibble: #{info}: #{tastiness} "
    tastiness > 30 ? "* #{result}" : result
  end

  def treat
    info = @snack_box.get_treat_info(@box_id)
    tastiness = @snack_box.get_treat_tastiness(@box_id)
    result = "Treat: #{info}: #{tastiness} "
    tastiness > 30 ? "* #{result}" : result
  end

end


class MetaCorgiSnacks
  def initialize(snack_box, box_id)
    @snack_box = snack_box
    @box_id = box_id

    # make sure this instance of MetaCorgiSnacks can get info
    # for all snacks in @snack_box

    # snack_box.methods.grep(/^get_(.*)_info$/).each do |snackMethod|
    #   MetaCorgiSnacks.define_snack snackMethod[4..-6]
    # end
    snack_box.methods.grep(/^get_(.*)_info$/) { MetaCorgiSnacks.define_snack $1 }
  end

  # def method_missing(name, *args)
  #   # in OUR use of this method, there will be NO additional args
  #   # however that IS one of the parameters of the method we are overriding
  #   # Your code goes here...
  #   snack = name.to_s
  #   if ["bone", "kibble", "treat"].include?(snack)
  #     info = @snack_box.send("get_#{snack}_info", @box_id)
  #     tastiness = @snack_box.send("get_#{snack}_tastiness", @box_id)
  #     result = "#{snack.capitalize}: #{info}: #{tastiness} "
  #     tastiness > 30 ? "* #{result}" : result
  #   else
  #     super
  #   end
  # end

  def self.define_snack(name)
    # Your code goes here...
    # so above, we wrote a method to "catch" calls to myCorgiSnacks.treat
    # which was undefined
    # and instead of calling some other method, we basically said 
    # ok well here's what I want you to output

    # NOW we are going to ACTUALLY create the methods we want in a DRY way
    # ON THE CLASS itself

    # that is, given the name of a snack, like "bone", we should be able to
    # call myMetaCorgi.bone, and have that method be defined for us

    define_method(name) { 
      info = @snack_box.send("get_#{name}_info", @box_id)
      tastiness = @snack_box.send("get_#{name}_tastiness", @box_id)
      result = "#{name.capitalize}: #{info}: #{tastiness} "
      tastiness > 30 ? "* #{result}" : result
    }
  end

  # these are snack options which will be defined on EVERY instance of MetaCorgiSnacks
  # define_snack("bone")
  # define_snack("kibble")
  # define_snack("treat")

  # we can automate this by looking through the available methods on SnackBox
  # (see initialize w grep above)

end