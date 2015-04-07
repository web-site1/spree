class CreateArtShipStates < ActiveRecord::Migration
  def change
    create_table :art_ship_states do |t|
      t.string :art_state ,index: true,limit: 25
    end
  end
end
