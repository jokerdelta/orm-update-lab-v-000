require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(id = nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

    def self.create_table
      sql = <<-SQL
      CREATE TABLE students(
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER)
      SQL
      DB[:conn].execute(sql)
    end

    def self.drop_table
      DB[:conn].execute("DROP TABLE students")
    end

    def save
      if self.id
        self.update
      else
        sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?)
        SQL
        DB[:conn].execute(sql, self.name, self.grade)
        @id = DB[:conn].execute("SELECT
        last_insert_rowid() FROM students")[0][0]
      end
    end

    def self.create(name, grade)
      new_song = self.new(name, grade)
      new_song.save
      new_song
    end

    def update
      sql = <<-SQL
      UPDATE students SET name = ?, grade = ?
      WHERE id = ?
      SQL
      DB[:conn].execute(sql, self.name, self.grade, self.id)
    end

    def self.find_by_name(name)
      sql = <<-SQL
      SELECT * FROM students
      WHERE name = ?
      SQL
      result = DB[:conn].execute(sql,name)[0]
      self.new(result[0], result[1], result[2])
    end

    def self.new_from_db(row)
      new_student = self.new(row[0], row[1], row[2])
      new_student
    end


end
