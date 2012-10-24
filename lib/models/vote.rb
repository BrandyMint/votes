class Vote < ActiveRecord::Base
  attr_accessor :dont_update_rating

  belongs_to :user
  belongs_to :voteable, :polymorphic => true

  before_validation do
    self.session_key = "user#{self.user.id}" if self.session_key.nil? and self.user.present?
    self.tone = 1 unless self.tone
  end

  before_save do
    self.power = if self.user
      self.user.power_of_vote
    else
      1
    end
    self.points = self.power * self.tone
  end

  validates_presence_of :voteable_type, :voteable_id, :tone, :session_key

  validates_uniqueness_of :user_id, :scope => [:voteable_type, :voteable_id], :if => lambda { |r| r.user_id }
  validates_uniqueness_of :session_key, :scope => [:voteable_type, :voteable_id]

  after_create :update_rating

  private

  def update_rating
    voteable.update_rating(self) unless dont_update_rating
  end
end
