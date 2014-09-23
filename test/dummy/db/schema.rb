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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140915220637) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: true do |t|
    t.string   "name",       null: false
    t.string   "subdomain"
    t.string   "logo"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "county"
    t.string   "postcode"
    t.string   "latitude"
    t.string   "longitude"
    t.string   "tel"
    t.string   "email"
    t.string   "reg_no"
    t.string   "vat_no"
    t.integer  "plan"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "companies", ["name"], name: "index_companies_on_name", unique: true, using: :btree
  add_index "companies", ["subdomain"], name: "index_companies_on_subdomain", unique: true, using: :btree

  create_table "mjbook_customers", force: true do |t|
    t.string   "title"
    t.string   "first_name"
    t.string   "surname"
    t.string   "position"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "county"
    t.string   "country"
    t.string   "postcode"
    t.string   "phone"
    t.string   "alt_phone"
    t.string   "email"
    t.string   "company"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjbook_expenditures", force: true do |t|
    t.decimal  "amount_paid",    precision: 8, scale: 2
    t.datetime "date"
    t.string   "ref"
    t.string   "method"
    t.integer  "user_id"
    t.string   "expend_receipt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjbook_expenseexpends", force: true do |t|
    t.string   "expense_id"
    t.string   "expenditure_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjbook_expenses", force: true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "supplier_id"
    t.integer  "hmrcexpcat_id"
    t.datetime "issue_date"
    t.datetime "due_date"
    t.decimal  "amount",        precision: 8, scale: 2
    t.decimal  "vat",           precision: 8, scale: 2
    t.string   "receipt"
    t.integer  "recurrence"
    t.string   "ref"
    t.string   "supplier_ref"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjbook_hmrcexpcats", force: true do |t|
    t.string   "category"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjbook_invoicemethods", force: true do |t|
    t.string   "method"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjbook_mileagemodes", force: true do |t|
    t.integer  "company_id"
    t.string   "mode"
    t.decimal  "rate",       precision: 8, scale: 2
    t.decimal  "hmrc_rate",  precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjbook_mileages", force: true do |t|
    t.integer  "project_id"
    t.integer  "mileagemode_id"
    t.integer  "user_id"
    t.integer  "hmrcexpcat_id"
    t.string   "start"
    t.string   "finish"
    t.integer  "return"
    t.decimal  "distance",       precision: 4, scale: 0
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjbook_productcategories", force: true do |t|
    t.integer  "company_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjbook_products", force: true do |t|
    t.integer  "company_id"
    t.integer  "productcategory_id"
    t.string   "item"
    t.decimal  "quantity",           precision: 8, scale: 0
    t.integer  "unit_id"
    t.decimal  "cost",               precision: 8, scale: 2
    t.decimal  "vat",                precision: 3, scale: 0
    t.decimal  "price",              precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjbook_projects", force: true do |t|
    t.string   "ref"
    t.string   "title"
    t.integer  "customer_id"
    t.text     "description"
    t.integer  "invoicemethod_id"
    t.string   "customer_ref"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjbook_suppliers", force: true do |t|
    t.string   "title"
    t.string   "first_name"
    t.string   "surname"
    t.string   "position"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "county"
    t.string   "country"
    t.string   "postcode"
    t.string   "phone"
    t.string   "alt_phone"
    t.string   "email"
    t.string   "company"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjweb_abouts", force: true do |t|
    t.integer  "company_id"
    t.string   "title"
    t.text     "text"
    t.integer  "image_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "link_text",  array: true
    t.string   "link_url",   array: true
  end

  create_table "mjweb_backgrounds", force: true do |t|
    t.string   "name"
    t.string   "background"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjweb_banks", force: true do |t|
    t.integer  "company_id"
    t.string   "title"
    t.text     "text"
    t.string   "link_text"
    t.string   "link_url"
    t.integer  "image_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjweb_books", force: true do |t|
    t.integer  "company_id"
    t.string   "title"
    t.text     "text"
    t.string   "link_text"
    t.string   "link_url"
    t.integer  "image_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjweb_contents", force: true do |t|
    t.integer  "company_id"
    t.integer  "tile_id"
    t.string   "display",    default: "All devices"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tile_ref"
  end

  create_table "mjweb_designs", force: true do |t|
    t.integer  "company_id"
    t.string   "tile_colour",   default: "#572c73"
    t.string   "background_id", default: "1"
    t.string   "font_id",       default: "1"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjweb_details", force: true do |t|
    t.integer  "company_id"
    t.string   "tagline"
    t.integer  "ecommerce"
    t.string   "facebook"
    t.string   "twitter"
    t.string   "googleplus"
    t.string   "linkedin"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjweb_events", force: true do |t|
    t.integer  "company_id"
    t.string   "topic"
    t.datetime "start"
    t.datetime "finish"
    t.string   "venue"
    t.string   "address"
    t.string   "postcode"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "date"
  end

  create_table "mjweb_fonts", force: true do |t|
    t.string   "name"
    t.string   "style"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjweb_helps", force: true do |t|
    t.string   "text",       default: "Help text to be added"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjweb_hours", force: true do |t|
    t.integer  "company_id"
    t.string   "monday_status",    default: "Open"
    t.datetime "monday_open",      default: '2000-01-01 09:30:00'
    t.datetime "monday_close",     default: '2000-01-01 17:30:00'
    t.string   "tuesday_status",   default: "Open"
    t.datetime "tuesday_open",     default: '2000-01-01 09:30:00'
    t.datetime "tuesday_close",    default: '2000-01-01 17:30:00'
    t.string   "wednesday_status", default: "Open"
    t.datetime "wednesday_open",   default: '2000-01-01 09:30:00'
    t.datetime "wednesday_close",  default: '2000-01-01 17:30:00'
    t.string   "thursday_status",  default: "Open"
    t.datetime "thursday_open",    default: '2000-01-01 09:30:00'
    t.datetime "thursday_close",   default: '2000-01-01 17:30:00'
    t.string   "friday_status",    default: "Open"
    t.datetime "friday_open",      default: '2000-01-01 09:30:00'
    t.datetime "friday_close",     default: '2000-01-01 17:30:00'
    t.string   "saturday_status",  default: "Open"
    t.datetime "saturday_open",    default: '2000-01-01 09:30:00'
    t.datetime "saturday_close",   default: '2000-01-01 17:30:00'
    t.string   "sunday_status",    default: "Open"
    t.datetime "sunday_open",      default: '2000-01-01 11:00:00'
    t.datetime "sunday_close",     default: '2000-01-01 16:30:00'
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjweb_images", force: true do |t|
    t.integer  "company_id"
    t.string   "name"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjweb_imagesettings", force: true do |t|
    t.integer  "image_id"
    t.integer  "content_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjweb_networkings", force: true do |t|
    t.integer  "company_id"
    t.string   "title"
    t.text     "text"
    t.string   "link_text"
    t.string   "link_url"
    t.integer  "image_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjweb_products", force: true do |t|
    t.integer  "company_id"
    t.string   "title"
    t.text     "text"
    t.string   "link_text"
    t.string   "link_url"
    t.integer  "image_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjweb_services", force: true do |t|
    t.integer  "company_id"
    t.string   "title"
    t.text     "text"
    t.string   "link_text"
    t.integer  "image_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "link_url",   array: true
  end

  create_table "mjweb_tiles", force: true do |t|
    t.string   "name"
    t.string   "partial_name"
    t.integer  "group"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjweb_trainings", force: true do |t|
    t.integer  "company_id"
    t.string   "title"
    t.text     "text"
    t.string   "link_text"
    t.string   "link_url"
    t.integer  "image_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjweb_webpages", force: true do |t|
    t.integer  "company_id"
    t.string   "title"
    t.text     "text"
    t.string   "link_text"
    t.string   "link_url"
    t.integer  "image_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "surname"
    t.string   "tel"
    t.integer  "company_id"
    t.integer  "role",                   default: 0
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["company_id"], name: "index_users_on_company_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

end
