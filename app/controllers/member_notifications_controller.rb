# frozen_string_literal: true

class MemberNotificationsController < ApplicationController
  before_action :set_member_notification, only: %i[show edit update destroy mark_seen]

  # GET /member_notifications or /member_notifications.json
  def index
    authorize(MemberNotification)
    @member_notifications = MemberNotification.where(member_id: current_member.id).all
    @member_notifications = @member_notifications.search(params[:query]) if params[:query].present?
    @pagy, @member_notifications = pagy(@member_notifications.reorder(sort_column => sort_direction), items: params.fetch(:count, 10))
  end

  def sort_column
    %w[title description event seen].include?(params[:sort]) ? params[:sort] : 'seen'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end

  # GET /member_notifications/1 or /member_notifications/1.json
  def show
    authorize(MemberNotification)
  end

  # GET /member_notifications/new
  def new
    authorize(MemberNotification)
    @member_notification = MemberNotification.new
  end

  # GET /member_notifications/1/edit
  def edit
    authorize(MemberNotification)
  end

  def toggle_seen
    @member_notification = MemberNotification.find(params[:id])
    @member_notification.update!(seen: !@member_notification.seen)
    redirect_back(fallback_location: member_notifications_path)
  end

  def mark_seen
    @member_notification = MemberNotification.find(params[:id])

    respond_to do |format|
      if @member_notification.update(seen: true)
        flash[:warning] = 'Member notification was marked as read'
        format.html { redirect_to(member_notification_url(@member_notification)) }
        format.json { render(:show, status: :ok, location: @member_notification) }
      else
        format.html { render(:edit, status: :unprocessable_entity) }
        format.json { render(json: @member_notification.errors, status: :unprocessable_entity) }
      end
    end
  end

  # POST /member_notifications or /member_notifications.json
  def create
    authorize(MemberNotification)
    @member_notification = MemberNotification.new(member_notification_params)

    respond_to do |format|
      if @member_notification.save
        flash[:success] = 'Member notification was successfully created.'
        format.html { redirect_to(member_notification_url(@member_notification)) }
        format.json { render(:show, status: :created, location: @member_notification) }
      else
        format.html { render(:new, status: :unprocessable_entity) }
        format.json { render(json: @member_notification.errors, status: :unprocessable_entity) }
      end
    end
  end

  # PATCH/PUT /member_notifications/1 or /member_notifications/1.json
  def update
    authorize(MemberNotification)
    respond_to do |format|
      if @member_notification.update(member_notification_params)
        flash[:success] = 'Member notification was successfully updated.'
        format.html { redirect_to(member_notification_url(@member_notification)) }
        format.json { render(:show, status: :ok, location: @member_notification) }
      else
        format.html { render(:edit, status: :unprocessable_entity) }
        format.json { render(json: @member_notification.errors, status: :unprocessable_entity) }
      end
    end
  end

  # DELETE /member_notifications/1 or /member_notifications/1.json
  def destroy
    @member_notification.destroy!

    respond_to do |format|
      flash[:success] = 'Member notification was successfully destroyed.'
      format.html { redirect_to(member_notifications_url) }
      format.json { head(:no_content) }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_member_notification
    @member_notification = MemberNotification.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def member_notification_params
    params.require(:member_notification).permit(:member_id, :notification_id, :seen)
  end
end
