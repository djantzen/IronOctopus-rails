class DayPlannersController < ApplicationController

  def new
    create_or_update
  end

  def create

  end

  def edit

  end

  def update

  end

  def create_or_update
    @trainer = User.find_by_login(params[:user_id])
    # return last week, this week and next week
    # longer historical views can be provided via proper reports
    # need to load: routine info, client list,

    @clients = @trainer.clients # order by last appointment
    @today = Date.today
    @last_week = (@today.beginning_of_week - 1.week .. @today.end_of_week - 1.week)
    @this_week = (@today.beginning_of_week .. @today.end_of_week)
    @next_week = (@today.beginning_of_week + 1.week .. @today.end_of_week + 1.week)
    @appointments = @trainer.appointments
    @recurring_appointments = @trainer.upcoming_recurring_appointments



  end

end
