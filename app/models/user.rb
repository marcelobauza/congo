class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable

  has_and_belongs_to_many :counties
  belongs_to :role

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
    role_id = params[:user][:role_id] unless params[:user].nil?
    email = params[:user][:email] unless params[:user].nil?
    disabled = params[:user][:disabled] unless params[:user].nil?
    nombre = params[:user][:complete_name] unless params[:user].nil?

    User.select("users.*").
      where(build_conditions({:role_id => role_id, :email => email,
                              :disabled => disabled,
                              :complete_name => nombre})).
                              order("complete_name")

  end
  def self.build_conditions(filters)
    if !filters[:role_id].blank?
      conditions = WhereBuilder.build_equal_condition("role_id", filters[:role_id])
    end

    if !filters[:email].blank?
      if (!conditions.nil?)
        conditions += Util.and
          conditions += WhereBuilder.build_equal_condition("email", filters[:email])
      else
        conditions = WhereBuilder.build_equal_condition("email", filters[:email])
      end
    end
    if !filters[:complete_name].blank?
      if (!conditions.nil?)
        conditions += Util.and
          conditions += WhereBuilder.build_like_condition("complete_name", filters[:complete_name])
      else
        conditions = WhereBuilder.build_like_condition("complete_name", filters[:complete_name])
      end
    end

    if filters[:disabled] == '1'
      if (!conditions.nil?)
        conditions += Util.and
          conditions += WhereBuilder.build_equal_condition("disabled", "TRUE")
      else
        conditions = WhereBuilder.build_equal_condition("disabled", "TRUE")
      end
    end
    conditions
  end
end
