class InvitationSerializer < ActiveModel::Serializer
  attributes :id, :email, :created_at, :updated_at

  link(:self) { invitation_url(object.id) }

  def url
    invitation_url(object)
  end

  def created_at
    "#{object.created_at.to_s(:short)}"
  end

  def updated_at
    "#{object.updated_at.to_s(:short)}"
  end
end
