trainer = Role.find_or_create_by!(name: 'trainer')
club = Club.find_or_create_by!(name: 'Club de Entrenamiento') do |c|
  c.description = 'Club principal de entrenamiento'
end

{
  'coach1@example.com' => ['Coach', 'Uno'],
  'coach2@example.com' => ['Coach', 'Dos']
}.each do |email, names|
  User.find_or_create_by!(email: email) do |u|
    u.google_id = SecureRandom.uuid
    u.role = trainer
    u.club = club
    u.build_profile(first_name: names[0], last_name: names[1])
  end
end

puts 'Coach accounts created.'
