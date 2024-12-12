class RemoveTitleDescColumn < ActiveRecord::Migration[8.0]
  def change
    remove_column :admin_articles, :title, :string
    remove_column :admin_articles, :description, :text

    # ลบคอลัมน์ title และ description จาก videos
    remove_column :videos, :title, :string
    remove_column :videos, :description, :text

    # ลบตาราง admin_videos
    drop_table :admin_videos
  end
end
