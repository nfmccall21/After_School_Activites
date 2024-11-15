class User < ApplicationRecord

  has_and_belongs_to_many :students
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum :role, %i[admin teacher parent]
  
end
