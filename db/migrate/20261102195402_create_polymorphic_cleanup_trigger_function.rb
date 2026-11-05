# frozen_string_literal: true

class CreatePolymorphicCleanupTriggerFunction < Code0::ZeroTrack::Database::Migration[1.1]
  def up
    create_polymorphic_cleanup_function
  end

  def down
    drop_polymorphic_cleanup_function
  end
end
