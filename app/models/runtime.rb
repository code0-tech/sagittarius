# frozen_string_literal: true

class Runtime < ApplicationRecord
  include TokenAttr

  belongs_to :namespace, optional: true

  token_attr :token, prefix: 's_rt_', length: 48

  has_many :data_types, inverse_of: :runtime

  validates :name, presence: true,
                   length: { minimum: 3, maximum: 50 },
                   allow_blank: false,
                   uniqueness: { case_sensitive: false, scope: :namespace_id }

  validates :description, length: { maximum: 500 }, exclusion: { in: [nil] }

  before_validation :strip_whitespace

  private

  def strip_whitespace
    name&.strip!
    description&.strip!
  end
end
