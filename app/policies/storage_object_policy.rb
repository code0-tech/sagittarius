# frozen_string_literal: true

# Files are project-scoped exactly like flows: access to a stored file is decided by access to its owning
# project, so a handle never grants access across project boundaries.
class StorageObjectPolicy < BasePolicy
  delegate { subject.project }
end
