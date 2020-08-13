class Project < ApplicationRecord
  include Discard::Model

  validates :title, presence: true, uniqueness: true
  has_many :items, dependent: :destroy
end
