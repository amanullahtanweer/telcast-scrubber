class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :company, presence: true
  validates :name, presence: true
  has_many :results

  default_scope { order(created_at: :desc) }

  serialize :datasets, Array


end
