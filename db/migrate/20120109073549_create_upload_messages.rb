class CreateUploadMessages < ActiveRecord::Migration
  def change
    create_table :upload_messages do |t|
      t.string :message
	    t.string :image
	    t.datetime :uploadtime
	    t.string :username
	    t.boolean :isselected
      t.timestamps
    end
  end
end
