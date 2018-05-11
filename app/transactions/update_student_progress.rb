require "dry/transaction"

class UpdateStudentProgress
  include Dry::Transaction

  step :process
  step :validate
  step :persist

  def process(input)
    Success(id: input["id"], lesson_number: input["lesson_number"], lesson_part_number: input["lesson_part_number"])
  end

  def validate(input)
    if input[:id].blank?
      Failure(:no_student_id_given)
    elsif input[:lesson_number].blank?
      Failure(:no_lesson_number_given)
    elsif input[:lesson_part_number].blank?
      Failure(:no_lesson_part_number_given)
    else
      Success(input)
    end
  end

  # If all necessary data exists, create a new lesson progress reocrd for student, lesson, and lesson part
  def persist(input)
    if student = Student.find_by(id: input[:id])
      if lesson = Lesson.find_by(progression_order: input[:lesson_number])
        if lesson_part = lesson.lesson_parts.find_by(progression_order: input[:lesson_part_number])
          if progress = StudentLessonProgress.where(student: student, lesson: lesson, lesson_part: lesson_part).first_or_create
            Success(student.reload.highest_lesson_progress)
          else
            Failure(progress.errors.full_messages)
          end
        else
          Failure(:no_lesson_part_with_that_number)
        end
      else
        Failure(:no_lesson_with_that_number)
      end
    else
      Failure(:no_student_with_that_id)
    end
  end

end
