class API::V1::StudentsController < ApplicationController

	# POST /api/v1/students
	def create
    respond_to do |format|

    	response_json = CreateStudent.new.call(permitted_student_params) do |m|

    		m.success do |student_record|
    			student_record
    		end

  		  m.failure :validate do |error|
  		  	{ error: error.to_s.gsub('_', ' ').humanize }
  		  end

  			m.failure do |error|
  				{ error: error.to_s.gsub('_', ' ').humanize }
  			end

    	end.to_json

      format.json { render json: response_json }

    end
	end

  # GET /apt/v1/students/:id/get_lesson_progress
  def get_lesson_progress
    respond_to do |format|
      if student
        format.json { render json: { student: student, lesson_progress: student.highest_lesson_progress }.to_json }
      else
        format.json { render json: { error: 'No student with that id' }.to_json }
      end
    end
  end

  # GET /apt/v1/students/report
  def report
    respond_to do |format|
      if teacher
        if params.fetch(:classroom_id, nil) && classroom
          format.json { render json: { students: teacher.students.in_classroom(classroom.try(:id)).map(&:as_hash) }.to_json }
        elsif !classroom
          format.json { render json: { students: teacher.students.map(&:as_hash) }.to_json }
        else
          format.json { render json: { error: 'No classroom with that id' }.to_json }
        end
      else
        format.json { render json: { error: 'No teacher with that id' }.to_json }
      end
    end
  end

	# PUT 	/api/v1/students/:id
	# PATCH /api/v1/students/:id
	def update
    respond_to do |format|
    	response_json = UpdateStudent.new.call(permitted_student_params) do |m|

    		m.success do |student_record|
    			student_record
    		end

  		  m.failure :validate do |error|
  		  	{ error: error.to_s.gsub('_', ' ').humanize }
  		  end

  			m.failure do |error|
  				{ error: error.to_s.gsub('_', ' ').humanize }
  			end

    	end.to_json

      format.json { render json: response_json }

    end
	end

  # PUT /api/v1/students/:id/update_lesson_progress
  def update_lesson_progress
    respond_to do |format|
      response_json = UpdateStudentLessonProgress.new.call(permitted_student_progress_params) do |m|

        m.success do |student_lesson_progress|
          { student: student, lesson_progress: student_lesson_progress }
        end

        m.failure :validate do |error|
          { error: error.to_s.gsub('_', ' ').humanize }
        end

        m.failure do |error|
          { error: error.to_s.gsub('_', ' ').humanize }
        end

      end.to_json

      format.json { render json: response_json }

    end
  end

	private

	def classroom
		@classroom ||= teacher.classrooms.find_by(id: params.fetch(:classroom_id, nil))
	end

  def permitted_student_params
    params.require(:student).permit(
      :id,
      :first_name,
      :last_name,
    )
  end

	def permitted_student_progress_params
		params.require(:student).permit(
			:id,
      :lesson_number,
      :lesson_part_number,
		)
	end

	def student
		@student ||= Student.find_by(id: params[:id])
	end

	def teacher
		@teacher ||= Teacher.find_by(id: params[:teacher_id])
	end

end