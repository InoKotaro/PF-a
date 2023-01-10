class Post < ApplicationRecord

  has_one_attached :image #ActiveStorage使用
  belongs_to :user #userが1側
  has_many :comments, dependent: :destroy #commentが多側
  has_many :favorites, dependent: :destroy #favoriteが多側

  #バリデーション 文字数指定あり
  #validates :title, length: { minimum: 1, maximum: 15 }, presence: true, uniqueness: true
  #validates :introduction, length: { minimum: 1, maximum: 30 }, presence: true, uniqueness: true
  #validates :image, presence: true, uniqueness: true

  #投稿時写真有無判断
  def get_image
    if image.attached?
      image
    else
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
  end

  #いいね機能で使用
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

end
