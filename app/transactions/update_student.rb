require "dry/transaction"

class UpdateStudent
  include Dry::Transaction

  step :process
  step :validate
  step :persist

  def process(input)
    Success(id: input["id"], first_name: input["first_name"], last_name: input["last_name"])
  end

  def validate(input)
    if input[:id].blank?
      Failure(:no_student_id_given)
    else
      Success(input)
    end
  end

  def persist(input)
    # Only update attributes where a valid value is given
    # Do not accept nil or '' values
    # Return errors on missing id, or update error (and return errors)
    if student = Student.find_by(id: input[:id])
      if student.update(input.delete_if { |k, v| v.blank? })
        Success(student)
      else
        Failure(student.errors.full_messages)
      end
    else
      Failure(:no_student_with_that_id)
    end
  end

end
