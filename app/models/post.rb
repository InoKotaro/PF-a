class Post < ApplicationRecord

  has_one_attached :image #ActiveStorage使用
  belongs_to :user #userが1側
  has_many :comments, dependent: :destroy #commentが多側
  has_many :favorites, dependent: :destroy #favoriteが多側

  #バリデーション 文字数指定あり
  #「uniqueness: false」で同じタイトル、本文投稿可能になる
  validates :image, presence: true
  validates :title, length: { minimum: 1, maximum: 9}, presence: true, uniqueness: false
  validates :introduction, length: { minimum: 1, maximum: 100 }, presence: true, uniqueness: false

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

  #------------------検索機能-----searchesコントローラで使うメソッド↓-----------------
  #投稿タイトル検索
  def self.looks(search, word)
    if search == "perfect_match"
      @post = Post.where("introduction LIKE?","#{word}")
    elsif search == "forward_match"
      @post = Post.where("introduction LIKE?","#{word}%")
    elsif search == "backward_match"
      @post = Post.where("introduction LIKE?","%#{word}")
    elsif search == "partial_match"
      @post = Post.where("introduction LIKE?","%#{word}%")
    else
      @post = Post.all.order(created_at: :desc).page(params[:page]) #投稿降順設定/ページネーション
    end
  end
  #----------------------------------------------------------------------------------

end
