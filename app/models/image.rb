class Image < ApplicationRecord
  validates :url, presence: true, format: URI.regexp(%w[http https])
end
