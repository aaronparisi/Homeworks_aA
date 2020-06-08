class Employee
    attr_reader :salary
    def initialize(name, title, salary, boss)
        @name, @title, @salary, @boss = name, title, salary, boss
    end

    def bonus(multiplier)
        @salary * multiplier
    end
end

class Manager < Employee
    attr_reader :employees
    def initialize(name, title, salary, boss, employees=[])
        super(name, title, salary, boss)
        @employees = employees
    end

    def bonus(multiplier)
        sub_sal = 0
        employees.each {|emp| sub_sal += emp.salary}
        sub_sal * multiplier
    end

    def add_employees(*emps)
        emps.each {|emp| @employees << emp}
    end
end

ned = Manager.new("Name", "Founder", 1_000_000, nil)
darren = Manager.new("Darren", "TA Manager", 78_000, ned)
shawna = Employee.new("Shawna", "TA", 12_000, darren)
david = Employee.new("David", "TA", 10_000, darren)

ned.add_employees(darren, shawna, david)
darren.add_employees(shawna, david)

puts ned.bonus(5) == 500_000
puts darren.bonus(4) == 88_000
puts david.bonus(3) == 30_000