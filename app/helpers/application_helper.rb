module ApplicationHelper
  # Active Storage 用プロフィール画像タグ（refile の attachment_image_tag の代替）
  def profile_image_tag(user, size: "80x80", fallback: "reading.jpg", **options)
    if user.profile_image.attached?
      image_tag user.profile_image, { size: size }.merge(options)
    else
      image_tag fallback, { size: size }.merge(options)
    end
  end
end
