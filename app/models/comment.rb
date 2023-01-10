class Comment < ApplicationRecord
  belongs_to :user #コメント視点でコメント送信者は一人なのでuserが1側
  belongs_to :post #コメント視点で結びつく投稿は一つなのでpostが1側
end
