class ChatSession < ApplicationRecord
  belongs_to :document
  has_many :inquires
  validates_presence_of :title
end
