class Token < ApplicationRecord
  has_secure_token :access_token
  belongs_to :user
end
