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

ActiveRecord::Schema.define(version: 20171117150435) do

  create_table "job_messages", force: :cascade do |t|
    t.integer "job_id"
    t.string "message_type", null: false
    t.datetime "created_at", null: false
    t.text "message", null: false
    t.index ["job_id"], name: "index_job_messages_on_job_id"
  end

  create_table "job_objects", force: :cascade do |t|
    t.integer "job_id"
    t.string "object_type"
    t.integer "object_id"
    t.index ["job_id"], name: "index_job_objects_on_job_id"
    t.index ["object_type", "object_id"], name: "index_job_objects_on_object_type_and_object_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.string "job_id", null: false
    t.string "job_type", null: false
    t.integer "status", null: false
    t.text "result"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_jobs_on_job_id", unique: true
    t.index ["status"], name: "index_jobs_on_status"
    t.index ["user_id"], name: "index_jobs_on_user_id"
  end

  create_table "resources", force: :cascade do |t|
    t.string "name"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
  end

end
