class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :company, presence: true
  validates :name, presence: true
  has_many :results

  belongs_to :reseller, class_name: 'User', foreign_key: 'parent_user_id', optional: true
  has_many :sub_users, class_name: 'User', foreign_key: 'parent_user_id'
  
  default_scope { order(created_at: :desc) }
  scope :resellers, -> { where(is_reseller: true) }

  serialize :datasets, Array

  before_create :generate_api_key


  private
  
  def generate_api_key
    self.api_key = SecureRandom.hex(5).upcase
  end

end
