class Alert < ApplicationRecord
  belongs_to :sensor

  scope :active, ->{ where(active: true) }
end
