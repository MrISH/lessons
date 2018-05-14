# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_05_10_051102) do

  create_table "classrooms", force: :cascade do |t|
    t.integer "teacher_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["teacher_id"], name: "index_classrooms_on_teacher_id"
  end

  create_table "classrooms_students", force: :cascade do |t|
    t.integer "classroom_id"
    t.integer "student_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["classroom_id"], name: "index_classrooms_students_on_classroom_id"
    t.index ["student_id"], name: "index_classrooms_students_on_student_id"
  end

  create_table "lesson_parts", force: :cascade do |t|
    t.integer "lesson_id"
    t.integer "progression_order"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_lesson_parts_on_lesson_id"
    t.index ["progression_order"], name: "index_lesson_parts_on_progression_order"
  end

  create_table "lessons", force: :cascade do |t|
    t.string "name"
    t.integer "progression_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_lessons_on_name"
    t.index ["progression_order"], name: "index_lessons_on_progression_order"
  end

  create_table "student_lesson_progresses", force: :cascade do |t|
    t.integer "student_id"
    t.integer "lesson_id"
    t.integer "lesson_part_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_student_lesson_progresses_on_lesson_id"
    t.index ["lesson_part_id"], name: "index_student_lesson_progresses_on_lesson_part_id"
    t.index ["student_id"], name: "index_student_lesson_progresses_on_student_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teachers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
