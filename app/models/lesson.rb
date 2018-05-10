class Lesson < ApplicationRecord
	has_many :lesson_parts
	has_many :student_lesson_progresses
end
