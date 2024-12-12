class RemovePhotoColumn < ActiveRecord::Migration[8.0]
  def change
    remove_column :admin_articles, :photo, :string
  end
end
