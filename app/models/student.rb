class Student < ApplicationRecord
	has_and_belongs_to_many :classrooms
	has_many :student_lesson_progresses

	# Retrieve the highest lesson, and highest lesson part that student has achieved.
	# Limit to one, as we are only interested in the highest one.
	# If none exist, return empty hash, so `.to_json` can still be called on the result of this method
	def highest_lesson_progress
		# self.student_lesson_progresses.select(:id, :lesson_id, :lesson_part_id).limit(1).order(lesson_id: :desc, lesson_part_id: :desc).try(:first) ||
		# { id: 0, lesson_id: 0, lesson_part_id: 0 }

		self.student_lesson_progresses.select(:id, :lesson_id, :lesson_part_id).limit(1).order(lesson_id: :desc, lesson_part_id: :desc).try(:first).try(:as_hash) ||
		{ lesson_number: 0, lesson_part_number: 0 }

	end

end
