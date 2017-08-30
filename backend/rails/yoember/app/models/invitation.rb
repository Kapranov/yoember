class Invitation < ApplicationRecord
  before_save :downcase_fields

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: true,
    length: { minimum: 5, maximum: 25 },
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }

  private

  def downcase_fields
    self.email = email.downcase
  end
end
