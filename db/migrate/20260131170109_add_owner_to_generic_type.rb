# frozen_string_literal: true

class AddOwnerToGenericType < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    add_reference :generic_types, :owner, polymorphic: true
  end
end
