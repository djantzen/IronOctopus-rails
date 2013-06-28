class InvitationsController < ApplicationController

  before_filter :authenticate_user, :except => [:accept]
  respond_to :html

  def new
    @invitation = Invitation.new
    @licenses_remaining = current_user.unused_licenses.count
  end

  def accept
    uuid = params[:invitation_token]
    @invitation = Invitation.find_by_invitation_uuid(uuid)
    @user = User.find_by_email(@invitation.email_to)
    if @user.nil?
      @user = User.new
    else
      Invitation.transaction do
        @user.trainers << @invitation.trainer
        license = @invitation.license
        license.status = 'assigned'
        license.save
        @invitation.accepted = true
        @invitation.save
      end
      redirect_to root_path
    end

  end

  def create
    Invitation.transaction do
      @email_to = params[:invitation][:email_to]
      license = current_user.unused_licenses.first
      mail = UserMailer.invitation_email(current_user, @email_to, license, request)
      mail.deliver
      license.status = 'pending'
      license.save
    end

  end

end