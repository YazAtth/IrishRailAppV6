class CreateSavedJourneys < ActiveRecord::Migration[7.0]
  def change
    create_table :saved_journeys do |t|
      t.string :origin_station
      t.string :destination_station
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
