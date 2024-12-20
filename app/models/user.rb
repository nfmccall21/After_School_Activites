class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :google_oauth2 ]

  has_and_belongs_to_many :students
  enum :role, %i[admin teacher parent]

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data["email"]).first

    # Uncomment the section below if you want users to be created if they don't exist
    unless user
      user = User.create(email: data["email"],
                         password: Devise.friendly_token[0, 20],
                         role: :parent)
    end
    user
  end

  def self.by_search_string(search)
    User.where("email LIKE ?", "%#{search}%")
  end
end
