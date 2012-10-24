require 'spec_helper'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

def setup_db
  ActiveRecord::Schema.define(:version => 1) do
    create_table "votes", :force => true do |t|
      t.integer  "voteable_id",                  :null => false
      t.string   "voteable_type",                :null => false
      t.integer  "points",        :default => 0, :null => false
      t.integer  "user_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "session_key",                  :null => false
      t.integer  "power"
      t.integer  "tone"
    end

    add_index "votes", ["voteable_id", "voteable_type", "session_key"], :name => "index_rates_on_rateable_id_and_rateable_type_and_session_key", :unique => true
    add_index "votes", ["voteable_id", "voteable_type", "user_id"], :name => "index_rates_on_rateable_id_and_rateable_type_and_user_id"

    create_table "users", :force => true do |t|
      t.string   "login",                  :limit => 50,                                                      :null => false
      t.decimal  "base_rating",                          :precision => 10, :scale => 0, :default => 0,        :null => false
      t.decimal  "rating",                               :precision => 10, :scale => 0, :default => 0,        :null => false
    end
  end

  User.create(:login=>'test_login')
end

class User < ActiveRecord::Base
  be_voteable
  be_voter
end

# drop all tables
def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end


describe 'Voting' do
  before do
    setup_db
  end

  after do
    teardown_db
  end

  it "should count vote" do
    user = User.first
    user.votes.all
    user.votes.create(:tone => -1, :user => user)
    user.reload.rating.should be -1
  end

end