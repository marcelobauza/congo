class User < ApplicationRecord

  include Util
  include Users::Downloads
  include Users::Export


  #has_paper_trail
  # Include default devise modules. Others available are:
  # :recoverable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :rememberable, :validatable, :session_limitable, :registerable, :confirmable

  has_many :counties_users
  has_many :counties, through: :counties_users
  has_many :regions_users
  has_many :regions, through: :regions_users, dependent: :destroy
  has_many :feedbacks
  has_many :downloads_users
  has_many :flex_orders
  has_many :flex_reports
  has_many :user_polygons, dependent: :destroy
  belongs_to :company
  belongs_to :role

  accepts_nested_attributes_for :flex_orders, :reject_if => lambda {|a| a[:amount].blank? }

  validate :is_rut_valid

  def is_rut_valid
    Util.is_rut_valid?(self, :rut, true)
  end

  def active_for_authentication?
    super && !disabled
  end

  def to_s
    self.complete_name
  end

  def self.current
    Thread.current[:user]
  end

  def self.current=(user)
    @current_user = user
  end

  def self.is_active? token
    return token.nil? ? false : !find_by_token(token).nil?
  end

  def self.get_users_by_filters(params)
    role_id       = params[:user][:role_id] unless params[:user].nil?
    email         = params[:user][:email] unless params[:user].nil?
    status        = params[:user][:disabled] unless params[:user].nil?
    complete_name = params[:user][:complete_name] unless params[:user].nil?

    query = User.joins(:company).all
    query = query.filter_role role_id if role_id.present?
    query = query.filter_email email if email.present?
    query = query.filter_complete_name complete_name if complete_name.present?
    query = query.filter_status status

    query
  end

  def self.filter_role role_id
    where(role_id: role_id)
  end

  def self.filter_email email
    where(email: email)
  end

  def self.filter_complete_name name
    where('complete_name ilike ?', "%#{name}%")
  end

  def self.filter_status status
    status = (status.nil? || status == "0") ? [false, nil] : true

    where(disabled: status)
  end

  protected
    def password_required?
      !persisted? || !password.blank? || !password_confirmation.blank?
    end
end
