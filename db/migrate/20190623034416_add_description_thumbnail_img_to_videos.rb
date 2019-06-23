class AddDescriptionThumbnailImgToVideos < ActiveRecord::Migration[5.2]
  def change
    add_column :videos, :description, :string
    add_column :videos, :thumbnail_img, :string
  end
end
