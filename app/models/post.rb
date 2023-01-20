class Post < ApplicationRecord

  has_one_attached :image #ActiveStorage使用
  belongs_to :user #userが1側
  has_many :comments, dependent: :destroy #commentが多側
  has_many :favorites, dependent: :destroy #favoriteが多側

  #バリデーション 文字数指定あり
  validates :image, presence: true
  validates :title, length: { minimum: 1, maximum: 15}, presence: true, uniqueness: true
  validates :introduction, length: { minimum: 1, maximum: 200 }, presence: true, uniqueness: true

  #投稿時写真有無判断
  def get_image
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
      image
  end

  #いいね機能で使用
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  #投稿タイトル検索
  def self.looks(search, word)
    if search == "perfect_match"
      @post = Post.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @post = Post.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @post = Post.where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      @post = Post.where("title LIKE?","%#{word}%")
    else
      @post = Post.all
    end
  end

end
