module UsersHelper

  # 引数で与えられたユーザーのGravatar画像を返す
  def gravatar_for(user)
    dummy_mail = "pool@example.com"
    gravatar_id = Digest::MD5::hexdigest(dummy_mail.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end