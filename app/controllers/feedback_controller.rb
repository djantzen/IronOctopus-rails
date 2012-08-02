class FeedbackController < ApplicationController
  respond_to :json
  def create

    @feedback = Feedback.new(:user_id => params["user_id"], :remarks => params["feedback"]["remarks"])
    @feedback.save
    #respond_to do |format|
    #  if @feedback.save
    #    format.html { redirect_to(@feedback, :notice => 'Feedback recorded.') }
    #    format.js
    #  else
    #    format.html { render :action => "new" }
    #    format.js
    #  end
    #end

  end

  def index
  end

  def show
  end

end
