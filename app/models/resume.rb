class Resume < ApplicationRecord
  belongs_to :user

  has_neighbors :embedding

  validates :filename, presence: true

  scope :nearest_to, ->(embedding, limit: 5) {
    nearest_neighbors(:embedding, embedding, distance: "cosine").limit(limit)
  }
end
