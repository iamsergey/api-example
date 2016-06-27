class CreateHotels < Sequel::Migration
  def up
    create_table :hotels do
      primary_key :id
      String :name
      String :address
      String :accommodation_type
    end
  end

  def down
    drop_table :hotels
  end
end
