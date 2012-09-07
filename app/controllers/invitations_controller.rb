class InvitationsController < ApplicationController

  respond_to :html

  def new
    @invitation = Invitation.new
    @licenses_remaining = current_user.unused_licenses.count
  end

  def accept
#    Invitation.transaction do
      uuid = params[:invitation_token]
      @invitation = Invitation.find_by_invitation_uuid(uuid)
#      @license = @invitation.license
#      @license.status = 'assigned'
#      @license.save
#      @invitation.accepted_at = Time.new
#      @invitation.save
      @user = User.new
#    end
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