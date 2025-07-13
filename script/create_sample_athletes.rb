normal_role = Role.find_or_create_by!(name: 'normal')
club = Club.find_or_create_by!(name: 'Club de Entrenamiento') do |c|
  c.description = 'Club principal de entrenamiento'
end

{
  'athlete1@example.com' => ['Atleta', 'Uno'],
  'athlete2@example.com' => ['Atleta', 'Dos']
}.each do |email, names|
  User.find_or_create_by!(email: email) do |u|
    u.google_id = SecureRandom.uuid
    u.role = normal_role
    u.club = club
    u.build_profile(first_name: names[0], last_name: names[1])
  end
end

puts 'Athlete accounts created.'
