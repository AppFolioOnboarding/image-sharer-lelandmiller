class Image < ApplicationRecord
  validates :url, presence: true, format: URI.regexp(%w[http https])
  acts_as_taggable
  validates :tag_list, presence: true
end
