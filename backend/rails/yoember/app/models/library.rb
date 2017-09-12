class Library < ApplicationRecord
  before_save :downcase_fields

  validates_presence_of :name, :address, :phone

  self.per_page = 10

  private

  def downcase_fields
    self.name = name.downcase
    self.address = address.downcase
    self.phone = phone.downcase
  end
end
