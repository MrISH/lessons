class StudentLessonProgress < ApplicationRecord
	belongs_to :student
	belongs_to :lesson
	belongs_to :lesson_part
end
