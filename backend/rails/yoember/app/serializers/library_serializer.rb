class LibrarySerializer < ActiveModel::Serializer
  attributes :id, :name, :address, :phone, :created_at, :updated_at

  link(:self) { library_url(object.id) }

  def url
    library_url(object)
  end

  def created_at
    "#{object.created_at.to_s(:short)}"
  end

  def updated_at
    "#{object.updated_at.to_s(:short)}"
  end
end
