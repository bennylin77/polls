# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140406152632) do

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "poll_id"
    t.integer  "poll_option_id"
    t.text     "content"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "facebooks", :force => true do |t|
    t.string   "identifier"
    t.string   "access_token"
    t.string   "username"
    t.integer  "user_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "name",         :default => ""
  end

  create_table "like_options", :force => true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.integer  "sub_comment_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "poll_option_histories", :force => true do |t|
    t.integer  "count"
    t.integer  "poll_option_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "poll_options", :force => true do |t|
    t.string   "title"
    t.integer  "poll_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "user_id"
    t.boolean  "verified_c", :default => true, :null => false
  end

  create_table "polls", :force => true do |t|
    t.integer  "user_id"
    t.integer  "kind"
    t.boolean  "verified_c",  :default => true, :null => false
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "reference_accepts", :force => true do |t|
    t.integer  "reference_id"
    t.integer  "user_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "reference_clicks", :force => true do |t|
    t.integer  "reference_id"
    t.integer  "user_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "references", :force => true do |t|
    t.integer  "poll_id"
    t.integer  "user_id"
    t.integer  "article_id"
    t.integer  "poll_option_id"
    t.integer  "kind"
    t.text     "link"
    t.boolean  "verified_c",     :default => true, :null => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "sub_comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.integer  "poll_option_id"
    t.text     "content"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "user_option_histories", :force => true do |t|
    t.integer  "user_option_id"
    t.integer  "poll_option_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "user_options", :force => true do |t|
    t.integer  "user_id"
    t.integer  "poll_option_id"
    t.string   "src_ip"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.integer  "age"
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "birthday"
  end

end
