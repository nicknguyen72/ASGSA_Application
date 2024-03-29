class NotificationsController < ApplicationController
  before_action :set_notification, only: %i[ show edit update destroy delete_confirmation]

  # GET /notifications or /notifications.json
  def index
    @notifications = Notification.all
  end

  # GET /notifications/1 or /notifications/1.json
  def show
  end

  # GET /notifications/new
  def new
    @notification = Notification.new
    Member.count.times {@notification.member_notifications.build}
  end

  # GET /notifications/1/edit
  def edit
  end

  # GET /notifications/1/delete_confirmation
  def delete_confirmation
    # Render delete_confirmation view
  end

  # POST /notifications or /notifications.json
  def create
    @notification = Notification.new(notification_params)
    @members = Member.all

    respond_to do |format|
      if @notification.save
        # creates a member_notification for all members id selected
        @members.each do |mem|
          @notification.member_notifications.create(member_id: mem.id, notification_id: @notification.id, seen: false)
        end
        #sends emails to all members if selected
        if params[:send_email] == "1"
          MemberMailer.notification_email(@notification).deliver_now
        end
        format.html { redirect_to notification_url(@notification), notice: "Notification was successfully created." }
        format.json { render :show, status: :created, location: @notification }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notifications/1 or /notifications/1.json
  def update
    respond_to do |format|
      if @notification.update(notification_params)
        format.html { redirect_to notification_url(@notification), notice: "Notification was successfully updated." }
        format.json { render :show, status: :ok, location: @notification }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notifications/1 or /notifications/1.json
  def destroy
    @notification.destroy!

    respond_to do |format|
      format.html { redirect_to notifications_url, notice: "Notification was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notification
      @notification = Notification.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def notification_params
      params.require(:notification).permit(:description, :title, :date,  :event_id)
    end    
end
