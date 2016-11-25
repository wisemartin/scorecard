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

ActiveRecord::Schema.define(:version => 20161124223155) do

  create_table "courses", :force => true do |t|
    t.string   "name"
    t.string   "city"
    t.string   "state_or_province"
    t.string   "country"
    t.boolean  "private"
    t.integer  "user_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "divisions", :force => true do |t|
    t.string   "name"
    t.integer  "season_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "divisions", ["season_id"], :name => "index_divisions_on_season_id"

  create_table "handicapping_methods", :force => true do |t|
    t.integer  "number_used"
    t.integer  "number_considered"
    t.integer  "handicap_percent"
    t.boolean  "use_ratings"
    t.integer  "minimum_considered"
    t.boolean  "exclude_extremes"
    t.integer  "season_id"
    t.boolean  "use_usga_schedule"
    t.boolean  "ignore_unopposed_rounds"
    t.float    "max_handicap"
    t.boolean  "allow_positive_handicap"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.boolean  "callaway",                    :default => false
    t.integer  "callaway_percent"
    t.boolean  "rollover_season",             :default => true
    t.integer  "rollover_number_weeks"
    t.boolean  "use_stats_for_hole_handicap"
    t.boolean  "limit_to_max_hole_score"
    t.integer  "max_hole_score_type"
    t.integer  "max_hole_score_amount"
  end

  create_table "holes", :force => true do |t|
    t.integer  "tee_box_id"
    t.integer  "par"
    t.integer  "handicap_index"
    t.integer  "number"
    t.integer  "length"
    t.string   "length_unit_of_measure"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  add_index "holes", ["handicap_index", "tee_box_id"], :name => "index_holes_on_handicap_index_and_tee_box_id", :unique => true
  add_index "holes", ["number", "tee_box_id"], :name => "index_holes_on_number_and_tee_box_id", :unique => true
  add_index "holes", ["tee_box_id"], :name => "index_holes_on_tee_box_id"

  create_table "leagues", :force => true do |t|
    t.string   "name"
    t.string   "domain_identifier"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "organization_id"
  end

  add_index "leagues", ["domain_identifier"], :name => "index_leagues_on_domain_identifier", :unique => true
  add_index "leagues", ["name", "organization_id"], :name => "index_leagues_on_name", :unique => true
  add_index "leagues", ["organization_id"], :name => "index_leagues_on_organziation_id"

  create_table "matchups", :force => true do |t|
    t.integer  "week_id"
    t.integer  "home_team_id"
    t.integer  "visiting_team_id"
    t.decimal  "home_team_total",     :precision => 5, :scale => 2
    t.decimal  "visiting_team_total", :precision => 5, :scale => 2
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
  end

  add_index "matchups", ["home_team_id"], :name => "index_matchups_on_home_team_id"
  add_index "matchups", ["visiting_team_id"], :name => "index_matchups_on_visiting_team_id"
  add_index "matchups", ["week_id", "visiting_team_id", "home_team_id"], :name => "index_matchups_on_week_id_and_visiting_team_id_and_home_team_id"
  add_index "matchups", ["week_id"], :name => "index_matchups_on_week_id"

  create_table "max_hole_score_types", :force => true do |t|
    t.string "description"
  end

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.string   "city"
    t.integer  "state_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "organizations", ["state_id"], :name => "index_organizations_on_state_id"

  create_table "organizations_players", :force => true do |t|
    t.integer "organization_id"
    t.integer "player_id"
  end

  create_table "partners", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "player_league_handicaps", :force => true do |t|
    t.integer  "player_id"
    t.integer  "season_id"
    t.float    "handicap_index"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "players", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.string   "home_address"
    t.string   "city"
    t.string   "state_or_province"
    t.string   "country"
    t.string   "gender"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "players", ["email"], :name => "index_players_on_email", :unique => true

  create_table "players_seasons", :force => true do |t|
    t.integer "player_id"
    t.integer "season_id"
    t.boolean "fees_paid"
    t.boolean "skins_paid"
  end

  create_table "players_teams", :force => true do |t|
    t.integer "player_id"
    t.integer "team_id"
    t.integer "partner_id"
  end

  create_table "players_weeks_skins", :force => true do |t|
    t.integer  "players_season_id"
    t.integer  "week_id"
    t.float    "amount"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "ratings", :force => true do |t|
    t.float    "course_rating"
    t.integer  "slope_rating"
    t.integer  "tee_box_id"
    t.string   "type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "rounds", :force => true do |t|
    t.date     "date"
    t.integer  "player_id"
    t.integer  "score_card_id"
    t.integer  "listed",                     :default => 0
    t.integer  "tee_box_id"
    t.string   "type"
    t.float    "points",        :limit => 5
    t.float    "handicap",      :limit => 5
    t.integer  "gross_score"
    t.integer  "total_score"
    t.integer  "esc_score"
    t.float    "score_index",   :limit => 5
    t.float    "hin",           :limit => 5
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  create_table "schedules", :force => true do |t|
    t.integer  "season_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "score_cards", :force => true do |t|
    t.integer  "matchup_id"
    t.integer  "team_id"
    t.string   "type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "scores", :force => true do |t|
    t.integer  "hole_id"
    t.integer  "score"
    t.integer  "round_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "scores", ["hole_id", "round_id"], :name => "hole_and_round", :unique => true

  create_table "scoring_methods", :force => true do |t|
    t.integer  "season_id"
    t.string   "type"
    t.integer  "points_per_match"
    t.text     "description"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "seasons", :force => true do |t|
    t.string   "name"
    t.integer  "league_id"
    t.integer  "course_id"
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "eighteen_holes"
    t.boolean  "rotate_nines"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "roster_size"
    t.integer  "number_playing_each_match"
    t.boolean  "limit_subs_to_roster"
    t.boolean  "skins_paid_by_season"
    t.boolean  "gross_skins"
    t.boolean  "net_skins"
  end

  add_index "seasons", ["league_id"], :name => "index_seasons_on_league_id"

  create_table "states", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.integer  "division_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "tee_boxes", :force => true do |t|
    t.integer  "course_id"
    t.string   "name"
    t.string   "color"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tee_times", :force => true do |t|
    t.datetime "tee_time"
    t.string   "group"
    t.integer  "starting_hole"
    t.integer  "season_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "users", :force => true do |t|
    t.integer  "role_id"
    t.integer  "league_id"
    t.integer  "player_id"
    t.string   "login_id",        :limit => 200
    t.string   "password_digest"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "users", ["league_id", "role_id", "player_id"], :name => "index_users_on_league_id_and_role_id_and_player_id", :unique => true
  add_index "users", ["login_id"], :name => "index_users_on_login_id", :unique => true
  add_index "users", ["player_id"], :name => "index_users_on_player_id"
  add_index "users", ["role_id"], :name => "index_users_on_role_id"

  create_table "weeks", :force => true do |t|
    t.integer  "schedule_id"
    t.integer  "course_id"
    t.date     "date"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

end
