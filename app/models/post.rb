class Post < ApplicationRecord

  has_one_attached :image #ActiveStorage使用
  belongs_to :user #userが1側

  #投稿時写真有無判断
  def get_image
    if image.attached?
      image
    else
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
  end

end
