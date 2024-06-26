# frozen_string_literal: true

class MembersController < ApplicationController
  before_action :set_member, only: %i[show edit update destroy delete_confirmation]
  helper_method :sort_column, :sort_direction

  def index
    authorize(Member)
    @members = Member.all
    @members = @members.general_search(params[:query]) if params[:query].present?
    @members = @members.where(area_of_study: params[:area_of_study]) if params[:area_of_study].present?
    @pagy, @members = pagy(@members.reorder(sort_column => sort_direction), items: params.fetch(:count, 10))
  end

  def sort
    @members = Member.order("#{params[:sort_by]} #{params[:direction]}")
    render(:index)
  end

  def sort_column
    %w[member_id first_name last_name position points date_joined res_topic].include?(params[:sort]) ? params[:sort] : 'first_name'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end

  # GET /members/1 or /members/1.json
  def show
    @member = Member.find(params[:id])
    authorize(@member)
  end

  # GET /members/new
  # def new
  #   @member = Member.new
  #   authorize @member
  # end

  # GET /members/1/edit
  def edit
    authorize(@member)
  end

  # GET /members/1/delete_confirmation
  def delete_confirmation
    authorize(@member)
    # Render delete_confirmation view
  end

  # POST /members or /members.json
  # def create
  #   @member = Member.new(member_params)
  #   authorize @member

  #   respond_to do |format|
  #     if @member.save
  #       format.html { redirect_to member_url(@member), notice: "Member was successfully created." }
  #       format.json { render :show, status: :created, location: @member }
  #     else
  #       format.html { render :new, status: :unprocessable_entity }
  #       format.json { render json: @member.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PATCH/PUT /members/1 or /members/1.json
  def update
    authorize(@member)
    respond_to do |format|
      if @member.update(member_params)
        if @member.profile_completed?
          format.html { redirect_to(member_url(@member)) }
          flash[:success] = 'Profile was successfully updated.'
        else
          format.html { redirect_to(root_path) }
          flash[:success] = 'Profile was successfully created.'
          @member.update!(profile_completed: true)
        end
        format.json { render(:show, status: :ok, location: @member) }
      else
        format.html { render(:edit) }
        format.json { render(json: @member.errors, status: :unprocessable_entity) }
      end
    end
  end

  # DELETE /members/1 or /members/1.json
  def destroy
    authorize(@member)
    @member.destroy!

    respond_to do |format|
      if @member.destroyed?
        flash[:success] = 'Member was successfully deleted.'
        format.html { redirect_to(members_url) }
        format.json { head(:no_content) }
      else
        flash[:alert] = 'Can\'t delete last Admin User'
        format.html { redirect_to(members_path) }
        format.json { render(json: @member.errors, status: :unprocessable_entity) }
      end
    end
  end

  def allergies_list
    @members = Member.all
    @members = @members.allergies_search(params[:query]) if params[:query].present?
    @pagy, @members = pagy(@members.reorder(sort_column => sort_direction), items: params.fetch(:count, 10))
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_member
    @member = Member.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def member_params
    params.require(:member).permit(:first_name, :last_name, :email, :points, :position, :date_joined, :degree, :food_allergies, :status, :faculty,
                                   :res_topic, :res_lab, :res_pioneer, :res_description, :area_of_study
    )
  end
end
