class Api::VotesController < ApplicationController
  respond_to :json

  def create
    unless params[:voteable_type].blank? and params[:voteable_id].blank?
      voteable_class = params[:voteable_type].constantize
      voteable = voteable_class.find(params[:voteable_id])
    else
      voteable = nil
    end

    authorize! :vote, voteable

    vote = voteable.vote_by_current_visitor(current_user, session[:id]) || Vote.create!(
      :voteable => voteable,
      :session_key => session[:id],
      :user => current_user,
      :tone => params[:tone].to_i
    )

    render nothing: true
  end
end
