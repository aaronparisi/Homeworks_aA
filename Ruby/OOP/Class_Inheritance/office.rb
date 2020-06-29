class Employee
    attr_reader :name, :title, :salary
    attr_accessor :boss
    def initialize(name, title, salary, boss = nil)
        @name, @title, @salary = name, title, salary
        self.boss = boss
    end

    def boss=(aboss)
        @boss = aboss
        aboss.add_employees(self) unless aboss.nil?

        boss
    end

    def bonus(multiplier)
        self.salary * multiplier
    end
end

class Manager < Employee
    attr_reader :employees
    def initialize(name, title, salary, boss=nil, employees=[])
        super(name, title, salary, boss)
        @employees = employees
    end

    def bonus(multiplier)
        self.total_subsal * multiplier
    end

    def add_employees(*emps)
        emps.each {|emp| @employees << emp}
    end

    protected
    # these methods can only be called by the instance itself;
    # that means no other object can call them
    # so no other object would even know that bonus() uses this helper method

    def total_subsal()
        tot = 0
        self.employees.each do |emp|
            tot += emp.salary
            tot += emp.total_subsal if emp.is_a?(Manager)
        end
        #debugger
        tot
    end
end

ned = Manager.new("Name", "Founder", 1_000_000, nil)
darren = Manager.new("Darren", "TA Manager", 78_000, ned)
shawna = Employee.new("Shawna", "TA", 12_000, darren)
david = Employee.new("David", "TA", 10_000, darren)

puts ned.bonus(5) == 500_000
puts darren.bonus(4) == 88_000
puts david.bonus(3) == 30_000