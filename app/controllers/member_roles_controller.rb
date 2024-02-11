class MemberRolesController < ApplicationController
  before_action :set_member_role, only: %i[ show edit update destroy ]

  # GET /member_roles or /member_roles.json
  def index
    @member_roles = MemberRole.all
  end

  # GET /member_roles/1 or /member_roles/1.json
  def show
  end

  # GET /member_roles/new
  def new
    @member_role = MemberRole.new
  end

  # GET /member_roles/1/edit
  def edit
  end

  # POST /member_roles or /member_roles.json
  def create
    @member_role = MemberRole.new(member_role_params)

    respond_to do |format|
      if @member_role.save
        format.html { redirect_to member_role_url(@member_role), notice: "Member role was successfully created." }
        format.json { render :show, status: :created, location: @member_role }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @member_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /member_roles/1 or /member_roles/1.json
  def update
    respond_to do |format|
      if @member_role.update(member_role_params)
        format.html { redirect_to member_role_url(@member_role), notice: "Member role was successfully updated." }
        format.json { render :show, status: :ok, location: @member_role }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @member_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /member_roles/1 or /member_roles/1.json
  def destroy
    @member_role.destroy!

    respond_to do |format|
      format.html { redirect_to member_roles_url, notice: "Member role was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_member_role
      @member_role = MemberRole.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def member_role_params
      params.require(:member_role).permit(:id, :member_id, :role_id)
    end
end
