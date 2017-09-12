class InvitationsController < ApplicationController
  before_action :set_invitation, only: [:show, :update, :destroy]
  before_action :validate_type, only: [:create, :update]

  # GET /invitations
  def index
    @invitations = Invitation.order(email: :asc)
    json_response(Oj.dump(json_for(@invitations, meta: meta), mode: :compat))
  end

  # GET /invitations/:id
  def show
    json_response(Oj.dump(json_for(@invitation, meta: meta), mode: :compat))
  end

  # POST /invitations
  def create
    @invitation = Invitation.new(invitation_params)
    if @invitation.save
      json_response(Oj.dump(json_for(@invitation, meta: meta), status: :created, mode: :compat))
    else
      render json: @invitation, status: 422, serializer: ActiveModel::Serializer::ErrorSerializer, meta: default_meta
      # json_response(Oj.dump(@invitation.errors, meta: default_meta, status: :unprocessable_entity, mode: :compat))
    end
  end

  # PUT /invitations/:id
  def update
    if @invitation.update(invitation_params)
      #head :no_content
      json_response(Oj.dump(json_for(@invitation, meta: meta), mode: :compat))
    else
      json_response(Oj.dump(@invitation.errors, meta: default_meta, status: :unprocessable_entity, mode: :compat))
    end
  end
  #def update
  #  if @invitation.update_attributes(invitation_params)
  #    render json: @invitation, status: :ok, meta: default_meta
  #  else
  #    render_error(@invitation, :unprocessable_entity)
  #  end
  #end

  # DELETE /invitations/:id
  def destroy
    if @invitation.destroy
      json_response(Oj.dump({message: "The invitation has been deleted", meta: meta}, mode: :compat))
      #head 204
    else
      json_response(Oj.dump(@invitation.errors, meta: default_meta, status: :unprocessable_entity, mode: :compat))
    end
  end

  private

  def set_invitation
    @invitation = Invitation.find(params[:id])
  end

  def invitation_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params)
  end
end
