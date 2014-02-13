class Dataset < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :collections

  has_many :user_favorite_datasets
  has_many :favoriting_users, through: :user_favorite_datasets, source: :user

  validates :title, presence: true
  validates :user, presence: true

  before_save :set_description_plaintext

  def set_description_plaintext
    description_html = SanitizedRenderer.render(self.description)
    self.description_plaintext = Nokogiri::HTML(description_html).text
  end

  # Makes indexable in elasticsearch
  searchkick text_start: [:title]
  def search_data
    as_json only: [:title, :description_plaintext]
  end
end
