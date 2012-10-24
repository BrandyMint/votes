module Votes::ActiveRecordExt
  def be_voteable
    has_many :votes, :as => :voteable, :dependent => :destroy
    include VoteableInstanceMethods
  end

  def be_voter args={power:1}
    @voter_power_of_vote = args[:power]
    has_many :voter_votes, :class_name => 'Vote', :foreign_key => :user_id, :dependent => :destroy
    include VoterInstanceMethods
  end

  module VoterInstanceMethods
    def power_of_vote
      voter_power_of_vote = self.class.instance_variable_get(:@voter_power_of_vote)
      if voter_power_of_vote.is_a?(Numeric)
        voter_power_of_vote
      elsif voter_power_of_vote.is_a?(Proc)
        self.instance_exec(&voter_power_of_vote)
      else
        self.send(voter_power_of_vote)
      end
    end
  end

  module VoteableInstanceMethods
    def vote_by_current_visitor current_user, session
      if current_user
        vote_by_user(current_user)
      else
        vote_by_session_key(session)
      end
    end

    def vote_by_user user
      self.votes.find_by_user_id(user.id)
    end

    def vote_by_session_key session_key
      self.votes.find_by_session_key(session_key)
    end

    def update_rating(vote)
      self.update_attribute(:rating, self.rating + vote.points)
    end

    def recalculate_rating
      self.update_attribute(:rating, self.base_rating + self.votes.map(&:points).sum)
    end
  end
end