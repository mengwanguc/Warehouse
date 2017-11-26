class Invent < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true, numericality: { only_integer: true }

  validates :user_id, uniqueness: { scope: [:sku, :status] }

  validate :validate_user_id


private

  def validate_user_id
   errors.add(:user_id, "is invalid") unless User.exists?(id: self.user_id)
  end
end
