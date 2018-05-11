# Create 100 lessons, with 3 parts for each lesson

(1..100).step(1) do |lesson_num|

	# Find and assign lesson by `lesson_num`
	l = Lesson.includes(:lesson_parts).where(name: "L#{ lesson_num }", progression_order: lesson_num).first_or_create!
	puts "seeding L#{ lesson_num }"

	# Test presence of required LessonParts, create if necessary
	unless l.lesson_parts.pluck(:name).sort == ['P1', 'P2', 'P3'].sort
		(1..3).step(1) do |step_num|
			l.lesson_parts.where(name: "P#{ step_num }", progression_order: step_num).first_or_create!
			puts "seeding #{ l.name } P#{ step_num }"
		end
	end

end
