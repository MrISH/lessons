require "dry/transaction"

class CreateStudent
  include Dry::Transaction

  step :process
  step :validate
  step :persist

  def process(input)
    Success(first_name: input["first_name"], last_name: input["last_name"])
  end

  def validate(input)
    if input[:first_name].blank?
      Failure(:first_name_not_valid)
    elsif input[:last_name].blank?
      Failure(:last_name_not_valid)
    else
      Success(input)
    end
  end

  def persist(input)
    student = Student.create(input)

    Success(student)
  end

end
