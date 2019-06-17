class User < ApplicationRecord
  validates :name,  presence: true, uniqueness: { case_sensitive: false },
             length: {maximum: 50}
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.search(search) 
    if search
      User.where(['email LIKE ?', "%#{search}%"])
    else
      User.all
    end
  end
end
