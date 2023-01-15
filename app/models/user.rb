class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_image #ActiveStorage使用
  has_many :posts, dependent: :destroy #postが多側
  has_many :comments, dependent: :destroy #commentが多側
  has_many :favorites, dependent: :destroy #favoriteが多側

  #--------------------------------フォロー機能アソシエーション↓-------------------------------------
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy #中間テーブル
  has_many :followings, through: :relationships, source: :followed #一覧で使用
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy #中間テーブル
  has_many :followers, through: :reverse_of_relationships, source: :follower #一覧で使用
  #--------------------------------------------------------------------------------------------------

  #ユーザー名,自己紹介文バリデーション 文字数指定あり
  validates :name, length: { minimum: 2, maximum: 15 }, presence: true, uniqueness: true
  validates :introduction, length: { maximum: 30 }

  #プロフィール画像サイズ処理
  def get_profile_image(width, height)
    if profile_image.attached? == false
      file_path = Rails.root.join('app/assets/images/sample_image.jpg') #デフォルト画像
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed #設定後はユーザー指定の画像適用
  end

  #----------------フォロー機能---relationshipsコントローラで使うメソッド↓------------
  #フォロー時
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end
  #フォローを解除時
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end
  #フォロー判定
  def following?(user)
    followings.include?(user)
  end
  #-----------------------------------------------------------------------------------

  #------------------検索機能-----searchesコントローラで使うメソッド↓-----------------
  #ユーザー名検索
  def self.looks(search, word)
    if search == "perfect_match" #完全一致
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "forward_match" #前方一致
      @user = User.where("name LIKE?","#{word}%")
    elsif search == "backward_match" #後方一致
      @user = User.where("name LIKE?","%#{word}")
    elsif search == "partial_match" #部分一致
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end
  #----------------------------------------------------------------------------------

  #退会済みユーザーログイン制限
  def active_for_authentication?
    super && (is_valid == true)
  end

  #ゲストログイン機能
  def self.guest
    find_or_create_by!(name: 'guestuser' ,email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "guestuser"
    end
  end

  def is_guest?
    self.name == "guestuser"
  end


  def test
    puts "static"
  end

end