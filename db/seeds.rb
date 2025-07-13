# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

role = Role.find_or_create_by!(name: 'normal')
RolePermission.find_or_create_by!(role: role, name: 'race_predictor')

trainer = Role.find_or_create_by!(name: 'trainer')
RolePermission.find_or_create_by!(role: trainer, name: 'training_plan')

club = Club.find_or_create_by!(name: 'Club de Entrenamiento') do |c|
  c.description = 'Club principal de entrenamiento'
end

# Create admin role and default admin user
admin_role = Role.find_or_create_by!(name: 'admin')
admin_user = User.find_or_create_by!(email: 'admin@example.com') do |u|
  u.google_id = SecureRandom.uuid
  u.role = admin_role
  u.club = club
  u.build_profile
  u.admin = true if u.respond_to?(:admin=)
end
