class Student < ApplicationRecord
  has_and_belongs_to_many :classrooms
  has_many :student_lesson_progresses

  scope :in_classroom, -> (classroom_id) { distinct.joins(:classrooms).where(classrooms: { id: classroom_id || Classroom.ids }) }

  def as_hash
    {
      id:                       self.id,
      first_name:               self.first_name,
      last_name:                self.last_name,
      highest_lesson_progress:  highest_lesson_progress,
    }
  end

  # Retrieve the highest lesson, and highest lesson part that student has achieved.
  # Limit to one, as we are only interested in the highest one.
  # If none exist, return empty hash, so `.to_json` can still be called on the result of this method
  def highest_lesson_progress
    self.student_lesson_progresses.select(:lesson_id, :lesson_part_id).limit(1).order(lesson_id: :desc, lesson_part_id: :desc).try(:first).try(:as_hash) ||
    { lesson_number: 0, lesson_part_number: 0 }
  end

  # Create new student_lesson_progresses record for given lesson and lesson_part
  # Only allow progress to the next lesson_part, or next lesson if current lesson_part == 3
  # ie. do not allow student to skip a lesson or lesson part
  # Return a struct with a lovely error message in the case of lesson skipping, or the result
  # Allow a student to repeat a previous lesson, or lesson part, without changing/lowering their highest_lesson_progress result
  def progress_to_lesson(lesson:, lesson_part:)
    current_lesson_number       = highest_lesson_progress.fetch(:lesson_number, 0)
    current_lesson_part_number  = highest_lesson_progress.fetch(:lesson_part_number, 0)
    success                     = false
    error                       = ''

    if (current_lesson_number + 1) == lesson.progression_order
      # if student is progressing to next lesson, or progressing to part in current lesson
      if (current_lesson_part_number == 3)
        # and their current lesson part is the 3rd
        if (lesson_part.progression_order == 1)
          # let them progress
          success = true
          self.student_lesson_progresses.create(lesson: lesson, lesson_part: lesson_part)
        else
          # otherwise fail, prevent progression and return error
          success = false
          error   = :cannot_skip_lesson_parts
        end
      elsif (current_lesson_part_number < 2) && (lesson_part.progression_order == 3)
        # if attempting to go from part 0 or 1 to part 3, always fail, prevent progression, and return error
        success = false
        error   = :cannot_skip_lesson_parts
      elsif (current_lesson_part_number + 1) == lesson_part.progression_order
        # if next lesson step is current lesson step plus 1, we're all good
        # let them progress
        success = true
        self.student_lesson_progresses.create(lesson: lesson, lesson_part: lesson_part)
      end
    elsif (lesson.progression_order == current_lesson_number)
      if (current_lesson_part_number + 1) == lesson_part.progression_order
        # if next lesson step is current lesson step plus 1, we're all good
        # let them progress
        success = true
        self.student_lesson_progresses.create(lesson: lesson, lesson_part: lesson_part)
      elsif (current_lesson_part_number < 2) && (lesson_part.progression_order == 3)
        # if attempting to go from part 0 or 1 to part 3, always fail, prevent progression, and return error
        success = false
        error   = :cannot_skip_lesson_parts
      end
    elsif (lesson.progression_order < current_lesson_number)
      # if student is repeating previous lesson, let them
      success = true
      # no-op
    else
      success = false
      error   = :cannot_skip_lessons
    end

    OpenStruct.new(
      success: success,
      result:  highest_lesson_progress,
      error:  error,
    )
  end

end
