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

ActiveRecord::Schema.define(version: 20170904183548) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.string   "author_type"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree
  end

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "instructor_id"
    t.index ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "admin_users_roles", id: false, force: :cascade do |t|
    t.integer "admin_user_id"
    t.integer "role_id"
  end

  create_table "appointments", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "status"
    t.integer  "schedule_id"
    t.integer  "station_number"
    t.datetime "start"
    t.string   "description"
    t.text     "anomaly"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "cards", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "uid"
    t.string   "object"
    t.boolean  "active"
    t.string   "last4"
    t.string   "exp_month"
    t.string   "exp_year"
    t.string   "name"
    t.text     "address"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "phone"
    t.boolean  "primary",    default: false
    t.string   "brand"
  end

  create_table "configs", force: :cascade do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "credit_modifications", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "credits"
    t.text     "reason"
    t.integer  "pack_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "distributions", force: :cascade do |t|
    t.integer  "height"
    t.integer  "width"
    t.string   "description"
    t.text     "inactive_seats"
    t.text     "active_seats"
    t.integer  "total_seats"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.text     "painted_seat_positions"
  end

  create_table "emails", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "email_status"
    t.string   "email_type"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "expirations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "classes_left"
    t.datetime "last_class_purchased"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "instructors", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "picture"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.text     "bio"
    t.string   "quote"
    t.string   "picture_2"
    t.boolean  "active",     default: true
  end

  create_table "packs", force: :cascade do |t|
    t.string   "description"
    t.integer  "classes"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.float    "special_price"
    t.float    "price"
    t.integer  "expiration"
    t.boolean  "active",        default: true
  end

  create_table "promotions", force: :cascade do |t|
    t.string   "coupon"
    t.string   "description"
    t.float    "amount"
    t.boolean  "active"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["coupon"], name: "index_promotions_on_coupon", unique: true, using: :btree
  end

  create_table "promotions_users", id: false, force: :cascade do |t|
    t.integer "promotion_id"
    t.integer "user_id"
  end

  create_table "purchases", force: :cascade do |t|
    t.integer  "pack_id"
    t.integer  "user_id"
    t.string   "uid"
    t.string   "object"
    t.boolean  "livemode"
    t.string   "status"
    t.string   "description"
    t.integer  "amount"
    t.string   "currency"
    t.text     "payment_method"
    t.text     "details"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "expired",        default: false
  end

  create_table "referrals", force: :cascade do |t|
    t.integer  "owner_id"
    t.integer  "referred_id"
    t.float    "credits"
    t.boolean  "used",        default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.integer  "venue_id"
    t.integer  "distribution_id"
    t.string   "description"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "schedule_types", force: :cascade do |t|
    t.string  "description"
    t.boolean "active",      default: true
  end

  create_table "schedules", force: :cascade do |t|
    t.integer  "instructor_id"
    t.integer  "room_id"
    t.datetime "datetime"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "description"
    t.boolean  "free",             default: false
    t.integer  "schedule_type_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "classes_left"
    t.datetime "last_class_purchased"
    t.string   "picture"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.boolean  "active",                 default: true
    t.string   "provider",               default: "email", null: false
    t.string   "uid",                    default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.string   "nickname"
    t.string   "image"
    t.string   "email"
    t.json     "tokens"
    t.string   "phone"
    t.string   "conekta_id"
    t.datetime "expiration_date"
    t.string   "coupon"
    t.float    "credits",                default: 0.0
    t.boolean  "staff",                  default: false
    t.boolean  "test",                   default: false
    t.index ["email"], name: "index_users_on_email", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree
  end

  create_table "venues", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_foreign_key "promotions_users", "promotions"
  add_foreign_key "promotions_users", "users"
  add_foreign_key "roles_users", "roles"
  add_foreign_key "roles_users", "users"
end
