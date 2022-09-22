class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :reservations, dependent: :destroy

  enum role: { general: 0, admin: 1 }

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :reset_password_token, uniqueness: true, allow_nil: true

  validates :last_name, presence: true, length: { maximum: 255 }
  validates :first_name, presence: true, length: { maximum: 255 }
  validates :last_name_kana, presence: true, length: { maximum: 255 }
  validates :first_name_kana, presence: true, length: { maximum: 255 }
  validates :tel, presence: true
  validates :email, uniqueness: true, presence: true
end
