class Comment < ApplicationRecord
  belongs_to :user #userが1側
  belongs_to :post #postが1側

  #バリデージョン 一文字以上必要
  validates :comment, length: { minimum: 1 }
end

