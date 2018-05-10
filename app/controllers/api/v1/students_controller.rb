class API::V1::StudentsController < ApplicationController

	# POST /api/v1/students
	def create
    respond_to do |format|

    	response_json = CreateStudent.new.call(permitted_student_params) do |m|

    		m.success do |student|
    			student.to_json
    		end

  		  m.failure :validate do |error|
  		  	{ error: error.to_s.gsub('_', ' ').humanize }
  		  end

  			m.failure do |error|
  				{ error: error.to_s.gsub('_', ' ').humanize }
  			end

    	end

      format.json { render json: response_json }

    end
	end

	# PUT 	/api/v1/students/:id
	# PATCH /api/v1/students/:id
	def update
    respond_to do |format|
    	response_json = UpdateStudent.new.call(permitted_student_params) do |m|

    		m.success do |student|
    			student.to_json
    		end

  		  m.failure :validate do |error|
  		  	{ error: error.to_s.gsub('_', ' ').humanize }
  		  end

  			m.failure do |error|
  				{ error: error.to_s.gsub('_', ' ').humanize }
  			end

    	end

      format.json { render json: response_json }

    end
	end

	private

	def classroom
		@classroom ||= []
	end

	def permitted_student_params
		params.require(:student).permit(
			:id,
			:first_name,
			:last_name,
		)
	end

	def student
		@student ||= Student.find_by(id: params[:id])
	end

	def teacher
		@teacher ||= []
	end

end