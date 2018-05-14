require 'rails_helper'

RSpec.describe API::V1::StudentsController, type: :request do

  describe 'GET /api/v1/students/:id/get_lesson_progress' do

    before(:context) do
      @student = Student.create(first_name: 'Little', last_name: 'John')
    end

    context "existing student with no progress" do

      it "returns JSON representation of student and their lack of lesson progress" do
        get "/api/v1/students/#{ @student.id }/get_lesson_progress"

        expect(JSON.parse(response.body)).to eq(JSON.parse({student: @student, lesson_progress: { lesson_number: 0, lesson_part_number: 0 }}.to_json))
      end

    end

    context "existing student with some progress" do

      before(:example) do
        @lesson       = Lesson.first!
        @lesson_part  = @lesson.lesson_parts.first!
        @progress     = StudentLessonProgress.where(student: @student, lesson: @lesson, lesson_part: @lesson_part).first_or_create
      end

      it "returns JSON representation of student and their existing lesson progress" do
        get "/api/v1/students/#{ @student.id }/get_lesson_progress"

        expect(JSON.parse(response.body)).to eq(JSON.parse({student: @student, lesson_progress: { lesson_number: @lesson.progression_order, lesson_part_number: @lesson_part.progression_order }}.to_json))
      end

    end

    context "request student that does not exist" do

      it "returns JSON error message" do
        get "/api/v1/students/1000000/get_lesson_progress"

        expect(response.body).to eq({error: 'No student with that id'}.to_json)
      end

    end

  end

  describe 'PUT /api/v1/students/:id/update_lesson_progress' do

    before(:context) do
      @student = Student.create(first_name: 'Little', last_name: 'John')
    end

    context "existing student with no progress, valid new lesson data" do

      before(:example) do
        @lesson       = Lesson.first!
        @lesson_part  = @lesson.lesson_parts.first!
      end

      it "updates student's lesson progress and returns JSON representation of student and their new lesson progress" do
        put "/api/v1/students/#{ @student.id }/update_lesson_progress", params: { student: { id: @student.id, lesson_number: @lesson.progression_order, lesson_part_number: @lesson_part.progression_order } }

        expect(JSON.parse(response.body)).to eq(JSON.parse({student: @student, lesson_progress: { lesson_number: @lesson.progression_order, lesson_part_number: @lesson_part.progression_order }}.to_json))
      end

    end

    context "existing student with existing progress valid new lesson data" do

      before(:example) do
        @lesson           = Lesson.first!
        @lesson_part      = @lesson.lesson_parts.first!
        @progress         = StudentLessonProgress.where(student: @student, lesson: @lesson, lesson_part: @lesson_part).first_or_create
        @new_lesson       = Lesson.second!
        @new_lesson_part  = @new_lesson.lesson_parts.second!
      end

      it "updates student's lesson progress and returns JSON representation of student and their new lesson progress" do
        put "/api/v1/students/#{ @student.id }/update_lesson_progress", params: { student: { id: @student.id, lesson_number: @new_lesson.progression_order, lesson_part_number: @new_lesson_part.progression_order } }

        expect(JSON.parse(response.body)).to eq(JSON.parse({student: @student, lesson_progress: { lesson_number: @new_lesson.progression_order, lesson_part_number: @new_lesson_part.progression_order } }.to_json))
      end

    end

    context "existing student with no progress, invalid new lesson data" do

      it "returns JSON error message" do
        put "/api/v1/students/#{ @student.id }/update_lesson_progress", params: { student: { id: @student.id, lesson_number: 1_000_000, lesson_part_number: 1_000_000 } }

        expect(response.body).to eq({ error: 'No lesson with that number' }.to_json)
      end

    end

    context "existing student with no progress, invalid new lesson part data" do

      it "returns JSON error message" do
        put "/api/v1/students/#{ @student.id }/update_lesson_progress", params: { student: { id: @student.id, lesson_number: Lesson.first!.id, lesson_part_number: 1_000_000 } }

        expect(response.body).to eq({ error: 'No lesson part with that number' }.to_json)
      end

    end

    context "existing student with existing progress invalid new lesson data" do

      before(:example) do
        @lesson           = Lesson.first!
        @lesson_part      = @lesson.lesson_parts.first!
        @progress         = StudentLessonProgress.where(student: @student, lesson: @lesson, lesson_part: @lesson_part).first_or_create
      end

      it "returns JSON error message" do
        put "/api/v1/students/#{ @student.id }/update_lesson_progress", params: { student: { id: @student.id, lesson_number: 1_000_000, lesson_part_number: 1_000_000 } }

        expect(response.body).to eq({ error: 'No lesson with that number' }.to_json)
      end

    end

    context "existing student with existing progress invalid new lesson part data" do

      before(:example) do
        @lesson           = Lesson.first!
        @lesson_part      = @lesson.lesson_parts.first!
        @progress         = StudentLessonProgress.where(student: @student, lesson: @lesson, lesson_part: @lesson_part).first_or_create
      end

      it "returns JSON error message" do
        put "/api/v1/students/#{ @student.id }/update_lesson_progress", params: { student: { id: @student.id, lesson_number: Lesson.second!.progression_order, lesson_part_number: 1_000_000 } }

        expect(response.body).to eq({ error: 'No lesson part with that number' }.to_json)
      end

    end

    context "updating a student that does not exist" do

      it "returns JSON error message" do
        put "/api/v1/students/1000000/update_lesson_progress", params: { student: { id: 1_000_000, lesson_number: 1_000_000, lesson_part_number: 1_000_000 } }

        expect(response.body).to eq({error: 'No student with that id'}.to_json)
      end

    end

    context "updating a student to a too advanced lesson" do

      it "returns JSON error message" do
        put "/api/v1/students/#{ @student.id }/update_lesson_progress", params: { student: { id: @student.id, lesson_number: Lesson.second!.progression_order, lesson_part_number: 1 } }

        expect(response.body).to eq({error: 'Cannot skip lessons'}.to_json)
      end

    end

    context "updating a student to a too advanced lesson part" do

      it "returns JSON error message" do
        put "/api/v1/students/#{ @student.id }/update_lesson_progress", params: { student: { id: @student.id, lesson_number: Lesson.first!.progression_order, lesson_part_number: 3 } }

        expect(response.body).to eq({error: 'Cannot skip lesson parts'}.to_json)
      end

    end

    context "updating a student to previous lesson part" do
      before(:example) do
        @lesson           = Lesson.third!
        @lesson_part      = @lesson.lesson_parts.first!
        @progress         = StudentLessonProgress.where(student: @student, lesson: @lesson, lesson_part: @lesson_part).first_or_create
      end

      it "returns JSON error message" do
        put "/api/v1/students/#{ @student.id }/update_lesson_progress", params: { student: { id: @student.id, lesson_number: Lesson.first!.progression_order, lesson_part_number: 3 } }

        expect(JSON.parse(response.body)).to eq(JSON.parse({student: @student, lesson_progress: { lesson_number: @lesson.progression_order, lesson_part_number: @lesson_part.progression_order } }.to_json))
      end

    end

  end

  describe 'POST /api/v1/students' do

    context "valid data" do

      it "returns JSON respresentation of student record on successful create" do
        post "/api/v1/students", params: { student: { first_name: "Little", last_name: 'John' } }

        expect(response.body).to eq(Student.last!.to_json)
      end

    end

    context "invalid data" do

      it "returns JSON error message when student first name is blank" do
        post "/api/v1/students", params: { student: { first_name: nil, last_name: 'John' } }

        expect(response.body).to eq({ error: 'First name not valid' }.to_json)
      end

      it "returns JSON error message when student last name is blank" do
        post "/api/v1/students", params: { student: { first_name: "Little", last_name: nil } }

        expect(response.body).to eq({ error: 'Last name not valid' }.to_json)
      end

      it "returns JSON error message when student first and last name are blank" do
        post "/api/v1/students", params: { student: { first_name: nil, last_name: nil } }

        expect(response.body).to eq({ error: 'First name not valid' }.to_json)
      end

    end

  end

  describe 'PUT /api/v1/student/:id' do

    before(:context) do
      @student = Student.create(first_name: 'Little', last_name: 'John')
    end

    context "valid data" do

      it "returns JSON respresentation of student record on successful update" do
        put "/api/v1/students/#{ @student.id }", params: { student: { id: @student.id, first_name: "Little", last_name: 'Jerry' } }

        expect(JSON.parse(response.body)).to eq(JSON.parse(@student.reload.to_json))
        expect(@student.reload.last_name).to eq('Jerry')
      end

      it "does not blank out attribute when student first name is nil" do
        put "/api/v1/students/#{ @student.id }", params: { student: { id: @student.id, first_name: nil, last_name: 'Jerry' } }

        expect(JSON.parse(response.body)).to eq(JSON.parse(@student.reload.to_json))
        expect(@student.reload.first_name).to eq('Little')
        expect(@student.reload.last_name).to eq('Jerry')
      end

      it "does not blank out attribute when student first name is ''" do
        put "/api/v1/students/#{ @student.id }", params: { student: { id: @student.id, first_name: '', last_name: 'Jerry' } }

        expect(JSON.parse(response.body)).to eq(JSON.parse(@student.reload.to_json))
        expect(@student.reload.first_name).to eq('Little')
        expect(@student.reload.last_name).to eq('Jerry')
      end

      it "does not blank out attribute when student last name is nil" do
        put "/api/v1/students/#{ @student.id }", params: { student: { id: @student.id, first_name: "Big", last_name: nil } }

        expect(JSON.parse(response.body)).to eq(JSON.parse(@student.reload.to_json))
        expect(@student.reload.first_name).to eq('Big')
        expect(@student.reload.last_name).to eq('John')
      end

      it "does not blank out attribute when student last name is ''" do
        put "/api/v1/students/#{ @student.id }", params: { student: { id: @student.id, first_name: "Big", last_name: '' } }

        expect(JSON.parse(response.body)).to eq(JSON.parse(@student.reload.to_json))
        expect(@student.reload.first_name).to eq('Big')
        expect(@student.reload.last_name).to eq('John')
      end

    end

    context "invalid data" do

      it "returns a JSON error message when ID is blank" do
        put "/api/v1/students/#{ @student.id }", params: { student: { id: nil, first_name: "Big", last_name: 'John' } }

        expect(response.body).to eq({ error: 'No student id given' }.to_json)
        expect(@student.reload.first_name).to eq('Little')
        expect(@student.reload.last_name).to eq('John')
      end

      it "returns a JSON error message when ID does not exist" do
        put "/api/v1/students/1000000", params: { student: { id: 1_000_000, first_name: "Big", last_name: 'Jerry' } }

        expect(response.body).to eq({ error: 'No student with that id' }.to_json)
        expect(@student.reload.first_name).to eq('Little')
        expect(@student.reload.last_name).to eq('John')
      end


    end

  end

  describe 'PUT /api/v1/students/report' do

    before(:context) do
      @teacher            = Teacher.where(first_name: 'Sir', last_name: 'Teach').first_or_create!
      @classroom          = @teacher.classrooms.where(name: 'First Class').first_or_create!
      @student            = Student.create(first_name: 'Little', last_name: 'John')
      @classroom.students = [@student]
    end

    context "valid data" do

      it "returns JSON respresentation of all of a teachers students" do
        get "/api/v1/students/report", params: { teacher_id: @teacher.id }

        expect(response.body).to eq({ students: [@student.reload.as_hash] }.to_json)
      end

    end

  end


end
