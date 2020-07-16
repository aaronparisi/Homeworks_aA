require 'sqlite3'
require 'singleton'

class PlayDBConnection < SQLite3::Database
  include Singleton

  def initialize
    super('plays.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class Play
  attr_accessor :id, :title, :year, :playwright_id

  def self.all
    data = PlayDBConnection.instance.execute("SELECT * FROM plays")
    data.map { |datum| Play.new(datum) }
  end

  def self.find_by_title(title)
    # returns the Play instance with the matching title
    self.all.each {|aPlay| return aPlay if aPlay.title == title}

    raise "#{title} is not in the database, sorry!"
  end

  def self.find_by_playwright(name)
    PlayDBConnection.instance.execute(<<-SQL, name)
      select *
      from plays
      join playwrights on plays.playwright_id = playwrights.id
      where playwrights.name = ?
    SQL
  end

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @year = options['year']
    @playwright_id = options['playwright_id']
  end

  def create
    raise "#{self} already in database" if self.id
    PlayDBConnection.instance.execute(<<-SQL, self.title, self.year, self.playwright_id)
      INSERT INTO
        plays (title, year, playwright_id)
      VALUES
        (?, ?, ?)
    SQL
    self.id = PlayDBConnection.instance.last_insert_row_id
  end

  def update
    raise "#{self} not in database" unless self.id
    PlayDBConnection.instance.execute(<<-SQL, self.title, self.year, self.playwright_id, self.id)
      UPDATE
        plays
      SET
        title = ?, year = ?, playwright_id = ?
      WHERE
        id = ?
    SQL
  end
end


class Playwright

  attr_accessor :id, :name, :birth_year

  def self.all
    # returns all guys from the Playwright table
    data = PlayDBConnection.instance.execute("select * from playwrights")

    data.map {|datum| Playwright.new(datum)}
  end

  def self.find_by_name(name)
    # returns a playwright object with matching name, or nil
    Playwright.all.each {|pw| return pw if pw.name == name}

    raise "Nobody named #{name} in the database, sorry"
  end

  def initialize(options)
    @id = options['id']
    @name = options['name']
    @birth_year = options['birth_year']
  end

  def create
    # add the playwright's info as a row to the playwrights table
    raise "#{self.name} is already in there" if self.id

    PlayDBConnection.instance.execute(<<-SQL, self.name, self.birth_year)
      insert into playwrights (name, birth_year)
      values (?, ?)
    SQL

    self.id = PlayDBConnection.instance.last_insert_row_id
  end

  def update
    # update the corresponding row in the playwrights table
    # with the calling object's attributes
    raise "#{self.name} is not in the database" unless self.id

    PlayDBConnection.instance.execute(<<-SQL, self.name, self.birth_year, self.id)
      update playwrights
      set name = ?, birth_year = ?
      where id = ?
    SQL
  end

  def get_plays
    # returns all plays written by this playwright
    PlayDBConnection.instance.execute(<<-SQL, self.id)
      select *
      from plays
      where playwright_id = ?
    SQL
  end
end