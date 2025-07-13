trainer = Role.find_or_create_by!(name: 'trainer')
club = Club.find_or_create_by!(name: 'Club de Entrenamiento') do |c|
  c.description = 'Club principal de entrenamiento'
end

['coach1@example.com', 'coach2@example.com'].each do |email|
  User.find_or_create_by!(email: email) do |u|
    u.google_id = SecureRandom.uuid
    u.role = trainer
    u.club = club
    u.build_profile
  end
end

puts 'Coach accounts created.'
