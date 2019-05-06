class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable

  has_and_belongs_to_many :counties


  def self.current
    Thread.current[:user]
  end

  def self.current=(user)
    @current_user = user
  end

  def self.is_active? token
    return token.nil? ? false : !find_by_token(token).nil?
  end

end
