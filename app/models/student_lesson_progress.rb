class StudentLessonProgress < ApplicationRecord
	belongs_to :student
	belongs_to :lesson
	belongs_to :lesson_part

	delegate :progression_order, to: :lesson, prefix: true
	delegate :progression_order, to: :lesson_part, prefix: true

	def as_hash
		{
			lesson_number: 			self.lesson_progression_order,
			lesson_part_number: self.lesson_part_progression_order,
		}
	end

end
