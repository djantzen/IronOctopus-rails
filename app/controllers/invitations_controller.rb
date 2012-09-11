class InvitationsController < ApplicationController

  respond_to :html

  def new
    @invitation = Invitation.new
    @licenses_remaining = current_user.unused_licenses.count
  end

  def accept
    uuid = params[:invitation_token]
    @invitation = Invitation.find_by_invitation_uuid(uuid)
    @user = User.new
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