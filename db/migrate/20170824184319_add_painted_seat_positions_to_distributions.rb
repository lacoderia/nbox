class AddPaintedSeatPositionsToDistributions < ActiveRecord::Migration[5.0]
  def change
    add_column :distributions, :painted_seat_positions, :text
  end
end
