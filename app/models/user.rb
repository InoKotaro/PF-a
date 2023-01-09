class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_image #ActiveStorage使用

  has_many :posts, dependent: :destroy #postが多側

  #プロフィール画像サイズ処理
  def get_profile_image(width, height)
    if profile_image.attached?
      profile_image.variant(resize_to_limit: [width, height]).processed
    else
      file_path = Rails.root.join('app/assets/images/sample-author1.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
  end

end
