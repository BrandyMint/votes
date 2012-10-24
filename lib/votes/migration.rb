module Votes::Migration
  def create_votes_table
    create_table :votes do |t|
      t.references :voteable, :polymorphic => true, :null => false
      t.integer :points, :null => false, :default => 0
      t.integer :power
      t.integer :tone
      t.integer :user_id, :null => false

      t.timestamps

      yield(t) if block_given?
    end

    add_index :votes, [:voteable_id, :voteable_type, :user_id], :unique => true
    add_index :votes, [:user_id, :voteable_id, :voteable_type], :unique => true
  end

  def add_rating_columns(table_name)
    add_column table_name, :base_rating, :decimal, :null => false, :default => 0
    add_column table_name, :rating, :decimal, :null => false, :default => 0
  end
end