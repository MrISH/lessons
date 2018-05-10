require 'rails_helper'

RSpec.describe API::V1::StudentsController, type: :request do

  describe 'POST /api/v1/students' do

    context "success" do

      it "returns JSON respresentation of student record and their lesson progress on successful create" do
        post "/api/v1/students", params: { student: { first_name: "Little", last_name: 'John' } }

        expect(response.body).to eq(Student.last!.to_json)
      end

    end

    context "failure" do

      it "returns JSON error emssage when student first name is blank" do
        post "/api/v1/students", params: { student: { first_name: nil, last_name: 'John' } }

        expect(response.body).to eq({ error: 'First name not valid' }.to_json)
      end

      it "returns JSON error emssage when student last name is blank" do
        post "/api/v1/students", params: { student: { first_name: "Little", last_name: nil } }

        expect(response.body).to eq({ error: 'Last name not valid' }.to_json)
      end

      it "returns JSON error emssage when student first and last name are blank" do
        post "/api/v1/students", params: { student: { first_name: nil, last_name: nil } }

        expect(response.body).to eq({ error: 'First name not valid' }.to_json)
      end

    end

  end

  describe 'PUT /api/v1/student/:id' do

    before(:context) do
      @student = Student.create(first_name: 'Little', last_name: 'John')
    end

    context "success" do

      it "returns JSON respresentation of student record and their lesson progress on successful update" do
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

    context "failure" do

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

end
