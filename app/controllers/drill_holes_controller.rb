class DrillHolesController < ApplicationController

  include ApplicationHelper

  before_action :require_logged_in_user

  def show
    @drill_hole = DrillHole.find(params[:id])
    @layers = @drill_hole.layers.order(layer_order: :asc)
    @layer = Layer.new
    @materials = MaterialType.all

    @field_tests = []
    @lab_tests = []

    @layers.each do |l| 
      f_test = FieldTest.where(id: l.id).select('test_type, depth_from, depth_to').first
      l_test = LabTest.where(id: l.id).select('test_type, depth_from, depth_to').first
      @field_tests.push(f_test) 
      @lab_tests.push(l_test)
    end
    is_a_site_user
  end

  def create
    @drill_hole = DrillHole.new(drill_hole_params)
    @drill_hole.site_id = current_site
    @drill_hole.logged_by_id = current_user.id
    p @drill_hole
    @drill_hole.save
    redirect_to :back
  end

  def update
    @drill_hole = DrillHole.find(params[:id])
    @drill_hole.update_attributes(drill_hole_params)
    if @drill_hole.save
      respond_to do |format|
        format.json { render json: { save: true } }
      end
    end
  end

  def update_reviewer
    @drill_hole = DrillHole.find(params[:id])
    @user = User.find(session[:user_id])
    @user_initials = @user.first_name[0] + @user.last_name[0]
    @drill_hole.update_attributes(reviewed_by_id: @user.id, reviewed_by: @user_initials)
    if @drill_hole.save
      if params[:data] == "Send review completed email"
        UserMailer.review_complete_email(@drill_hole.logged_by_id, @drill_hole).deliver
      else
        UserMailer.review_start_email(@drill_hole.logged_by_id, @drill_hole).deliver
      end
      respond_to do |format|
        format.json { render json: { save: true } }
      end
    end
  end

  protected

  def drill_hole_params
    params.require(:drill_hole).permit(:name, :ground_elev, :depth, :logged_by, :water_level_start, :water_level_during, :water_level_end, :site_id, :dh_lat, :dh_lng, :hole_size, :method)
  end

end
