# frozen_string_literal: true

User.seed_once :username do |u|
  u.email = 'admin@code0.tech'
  u.username = 'Admin'
  u.password = 'password'
  u.admin = true
end

User.seed_once :username do |u|
  u.email = 'org-maintainer@code0.tech'
  u.username = 'Maintainer'
  u.password = 'password'
  u.admin = false
end

User.seed_once :username do |u|
  u.email = 'org-owner@code0.tech'
  u.username = 'Owner'
  u.password = 'password'
  u.admin = false
end

User.seed_once :username do |u|
  u.email = 'user@code0.tech'
  u.username = 'User'
  u.password = 'password'
  u.admin = false
end
