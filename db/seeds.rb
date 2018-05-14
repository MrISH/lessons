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

# Create two Teachers, with two classroom each, and some students for each, or both, classrooms
teacher_1 	= Teacher.where(first_name: 'Sir', last_name: 'Teach').first_or_create!
classroom_1 = teacher_1.classrooms.where(name: 'First Class').first_or_create!
classroom_2 = teacher_1.classrooms.where(name: 'Third Class').first_or_create!

teacher_2 	= Teacher.where(first_name: 'Miss', last_name: 'Teach').first_or_create!
classroom_3 = teacher_2.classrooms.where(name: 'Second Class').first_or_create!
classroom_4 = teacher_2.classrooms.where(name: 'Fourth Class').first_or_create!


student_1 = Student.where(first_name: 'Little', 	last_name: 'John').first_or_create!
student_2 = Student.where(first_name: 'Friar', 		last_name: 'Tuck').first_or_create!
student_3 = Student.where(first_name: 'Robbin', 	last_name: 'Hood').first_or_create!
student_4 = Student.where(first_name: 'Maid', 		last_name: 'Marian').first_or_create!
student_5 = Student.where(first_name: 'Sheriff', 	last_name: 'Nottingham').first_or_create!
student_6 = Student.where(first_name: 'Sir', 			last_name: 'Hiss').first_or_create!

classroom_1.students = [
	student_1,
	student_2,
]

classroom_2.students = [
	student_3,
	student_4,
]

classroom_3.students = [
	student_5,
	student_6,
]

classroom_4.students = [
	student_1,
	student_2,
	student_3,
	student_4,
	student_5,
	student_6,
]
