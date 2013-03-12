class Student
  attr_reader :courses

  def initialize(fname, lname)
    @fname = fname.capitalize
    @lname = lname.capitalize
    @courses = []
  end

  def name
    @fname + " " + @lname
  end

  def enroll(course)
    unless courses.include?(course) || has_conflict?(course)
      @courses << course
      course.add_student(self)
    end
  end

  def course_load
    load = Hash.new(0)
    @courses.each { |course| load[course.department] += course.num_credits }

    load
  end

  def has_conflict?(new_course)
    @courses.each do |enrolled_course|
      return true if Course.conflicts?(new_course, enrolled_course)
    end

    false
  end

  def inspect
  end
end

class Course
  attr_reader :students, :name, :department, :num_credits, :schedule

  def initialize(name, dept, num_credits)
    @name = name
    @department = dept
    @num_credits = num_credits
    @students = []
  end

  def self.conflicts?(course1, course2)
    sched1 = course1.schedule
    sched2 = course2.schedule

    sched1[:time] == sched2[:time] && self.duplicate_days?(course1, course2)
  end

  def schedule_course(days, time_block)
    @schedule = { :days => days, :time => time_block }
  end

  def add_student(student)
    unless @students.include?(student) || student.has_conflict?(self)
      @students << student
      student.enroll(self)
    end
  end

  def inspect
  end

  private

  def self.duplicate_days?(course1, course2)
    master = course1.schedule[:days] + course2.schedule[:days]
    master.count > master.uniq.count
  end
end