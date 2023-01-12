class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_image #ActiveStorage使用
  has_many :posts, dependent: :destroy #postが多側
  has_many :comments, dependent: :destroy #commentが多側
  has_many :favorites, dependent: :destroy #favoriteが多側
  #--------------------------------フォロー機能↓-------------------------------------
  #フォロー,フォロワーの関係
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :relationships, source: :followed #一覧で使用
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :follower #一覧で使用
  #--------------------------------フォロー機能↑-------------------------------------

  #バリデーション 文字数指定あり
  validates :name, length: { minimum: 2, maximum: 15 }, presence: true, uniqueness: true
  validates :introduction, length: { maximum: 30 }

  #----------------フォロー機能---リレーションシップコントで使うメソッド↓------------
    # フォローしたときの処理
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end
  # フォローを外すときの処理
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end
  # フォローしているか判定
  def following?(user)
    followings.include?(user)
  end
  #----------------フォロー機能---リレーションシップコントで使うメソッド↓------------




  #プロフィール画像サイズ処理
  def get_profile_image(width, height)
    if profile_image.attached?
      profile_image.variant(resize_to_limit: [width, height]).processed #設定後はユーザー指定の画像適用
    else
      file_path = Rails.root.join('app/assets/images/sample_image.jpg') #デフォルト画像
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
  end



end