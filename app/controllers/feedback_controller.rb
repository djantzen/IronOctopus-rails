class FeedbackController < ApplicationController
  respond_to :json, :html
  def create
    user = User.find_by_login(params[:user_id])
    @feedback = Feedback.new(:user_id => user.user_id, :remarks => params["feedback"]["remarks"])
  end

  def index
  end

  def show
  end

end
