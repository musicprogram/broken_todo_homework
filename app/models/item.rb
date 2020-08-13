class Item < ApplicationRecord
  include Discard::Model

  belongs_to :project
  validates :action,
    presence: true,
    uniqueness: {
                  scope: :project,
                  message: 'should be unique within a project'
                }
  validates :project_id, presence: true
  scope :complete, -> { where(done: true) }
end
