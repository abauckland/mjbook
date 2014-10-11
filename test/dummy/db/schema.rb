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

ActiveRecord::Schema.define(version: 20141011101854) do

  create_table "companies", force: true do |t|
    t.string   "name",                   null: false
    t.string   "subdomain",              null: false
    t.string   "domain",                 null: false
    t.string   "logo"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "county"
    t.string   "postcode"
    t.string   "latitude"
    t.string   "longitude"
    t.string   "tel"
    t.string   "alt_tel"
    t.string   "email"
    t.string   "reg_no"
    t.string   "vat_no"
    t.integer  "plan",       default: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "companies", ["name"], name: "index_companies_on_name", unique: true, using: :btree

  create_table "helps", force: true do |t|
    t.string   "item",       default: "Help text to be added"
    t.string   "text",       default: "Help text to be added"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjbook_companyaccounts", force: true do |t|
    t.integer  "company_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjbook_customers", force: true do |t|
    t.integer  "company_id"
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
    t.string   "company_name"
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
    t.integer  "company_id"
    t.integer  "user_id"
    t.integer  "exp_type"
    t.integer  "project_id"
    t.integer  "supplier_id"
    t.integer  "hmrcexpcat_id"
    t.datetime "date"
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
    t.integer  "company_id"
    t.string   "category"
    t.string   "group"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjbook_invoicemethods", force: true do |t|
    t.string   "method"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjbook_invoiceterms", force: true do |t|
    t.integer  "company_id"
    t.text     "terms"
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

  create_table "mjbook_misccategories", force: true do |t|
    t.integer  "company_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjbook_miscs", force: true do |t|
    t.integer  "misccategory_id"
    t.string   "item"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjbook_paymethods", force: true do |t|
    t.string   "method"
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
    t.integer  "vat_id"
    t.decimal  "vat_due",            precision: 3, scale: 0
    t.decimal  "price",              precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjbook_projects", force: true do |t|
    t.integer  "company_id"
    t.string   "ref"
    t.string   "title"
    t.integer  "customer_id"
    t.text     "description"
    t.integer  "invoicemethod_id"
    t.string   "customer_ref"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjbook_qgroups", force: true do |t|
    t.integer  "quote_id"
    t.integer  "ref",                                 default: 1
    t.integer  "group_order",                         default: 1
    t.string   "text",                                default: "Please add brief description of work"
    t.decimal  "sub_vat",     precision: 8, scale: 2, default: 0.0
    t.decimal  "sub_price",   precision: 8, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjbook_qlines", force: true do |t|
    t.integer  "qgroup_id"
    t.string   "cat",                                default: "#Please select category"
    t.string   "item",                               default: "Please select item"
    t.decimal  "quantity",   precision: 8, scale: 0, default: 0
    t.integer  "unit_id",                            default: 1
    t.decimal  "rate",       precision: 8, scale: 2, default: 0.0
    t.integer  "vat_id",                             default: 1
    t.decimal  "vat",        precision: 8, scale: 2, default: 0.0
    t.decimal  "price",      precision: 8, scale: 2, default: 0.0
    t.text     "note"
    t.integer  "linetype",                           default: 1
    t.integer  "line_order",                         default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjbook_quotes", force: true do |t|
    t.integer  "project_id"
    t.string   "ref"
    t.string   "title"
    t.string   "customer_ref"
    t.datetime "date"
    t.integer  "status"
    t.decimal  "total_vat",    precision: 8, scale: 2, default: 0.0
    t.decimal  "total_price",  precision: 8, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjbook_quoteterms", force: true do |t|
    t.integer  "company_id"
    t.text     "terms"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjbook_ratecategories", force: true do |t|
    t.integer  "company_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjbook_rates", force: true do |t|
    t.integer  "company_id"
    t.integer  "ratecategory_id"
    t.string   "item"
    t.decimal  "quantity",        precision: 8, scale: 0
    t.integer  "unit_id"
    t.decimal  "cost",            precision: 8, scale: 2
    t.integer  "vat_id"
    t.decimal  "vat",             precision: 3, scale: 0
    t.decimal  "price",           precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjbook_servicecategories", force: true do |t|
    t.integer  "company_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjbook_services", force: true do |t|
    t.integer  "company_id"
    t.integer  "servicecategory_id"
    t.string   "item"
    t.decimal  "quantity",           precision: 8, scale: 0
    t.integer  "unit_id"
    t.decimal  "cost",               precision: 8, scale: 2
    t.integer  "vat_id"
    t.decimal  "vat",                precision: 3, scale: 0
    t.decimal  "price",              precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjbook_suppliers", force: true do |t|
    t.integer  "company_id"
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
    t.string   "company_name"
    t.text     "notes"
    t.string   "vat_no"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjbook_units", force: true do |t|
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mjbook_vats", force: true do |t|
    t.string   "cat"
    t.decimal  "rate",       precision: 2, scale: 1
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
