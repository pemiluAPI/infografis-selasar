class CreateInfografisSelasars < ActiveRecord::Migration
  def change
    create_table :infografis_selasars do |t|
      t.string  :judul
      t.string  :url_infografis
      t.string  :type_id
    end
    add_index :infografis_selasars, :type_id
  end
end
