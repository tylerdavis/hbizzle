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

ActiveRecord::Schema.define(version: 20140813043247) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "actors", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "actors_movies", force: true do |t|
    t.integer "actor_id"
    t.integer "movie_id"
  end

  add_index "actors_movies", ["actor_id"], name: "index_actors_movies_on_actor_id", using: :btree
  add_index "actors_movies", ["movie_id"], name: "index_actors_movies_on_movie_id", using: :btree

  create_table "directors", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "directors_movies", force: true do |t|
    t.integer "director_id"
    t.integer "movie_id"
  end

  add_index "directors_movies", ["director_id"], name: "index_directors_movies_on_director_id", using: :btree
  add_index "directors_movies", ["movie_id"], name: "index_directors_movies_on_movie_id", using: :btree

  create_table "movies", force: true do |t|
    t.datetime "expire"
    t.string   "hbo_id"
    t.string   "image"
    t.string   "imdb_link"
    t.string   "imdb_rating"
    t.string   "rating"
    t.text     "summary"
    t.string   "title"
    t.string   "year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "rotten_critics_score"
    t.string   "rotten_audience_score"
    t.integer  "plays",                 default: 0
    t.string   "poster_uid"
    t.string   "big_poster_uid"
    t.string   "youtube_id"
  end

end
