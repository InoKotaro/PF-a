class Favorite < ApplicationRecord
  belongs_to :user #userが1側
  belongs_to :post #postが1側
end
