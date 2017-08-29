class InvitationsController < ApplicationController
  before_action :set_invitation, only: [:show, :update, :destroy]

  def index
    @invitations = Invitation.order(email: :asc)
    # render json: @invitations
    render json: Oj.dump(json_for(@invitations, meta: meta), mode: :compat)
  end

  def show
    # render json: @invitation
    render json: Oj.dump(json_for(@invitation, meta: meta), mode: :compat)
  end

  def create
    # @invitation = Invitation.new(invitation_params)
    @invitation = Invitation.new(params[:data][:attributes].permit!)
    if @invitation.save
      # render json: @invitation, status: :created, location: @invitation
      render json: Oj.dump(json_for(@invitation, meta: meta), mode: :compat)
    else
      render json: @invitation.errors, status: :unprocessable_entity
    end
  end

  def update
    if @invitation.update(invitation_params)
      # render json: @invitation
      render json: Oj.dump(json_for(@invitation, meta: meta), mode: :compat)
    else
      render json: @invitation.errors, status: :unprocessable_entity
    end
  end

  def destroy
    # @invitation.destroy
    if @invitation.destroy
      render json: { message: "invitation deleted" }.to_json, status: :ok
    else
      render json: @invitation.errors, status: :unprocessable_entity
    end
  end

  private

  def set_invitation
    @invitation = Invitation.find(params[:id])
  end

  def invitation_params
    params.require(:invitation).permit(:email)
  end
end
