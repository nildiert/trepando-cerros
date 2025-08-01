# frozen_string_literal: true

# Usage:
#   USER_EMAIL=coach@example.com bin/rails runner script/create_my_athletes.rb
#
# Creates sample athlete accounts and assigns them to the user specified by
# USER_EMAIL through the Coaching relation.

abort 'Please set USER_EMAIL with your account email' unless ENV['USER_EMAIL']

coach = User.find_by(email: ENV['USER_EMAIL'])
abort "User #{ENV['USER_EMAIL']} not found" unless coach

# ensure the coach belongs to a club for testing purposes
unless coach.club
  club = Club.first_or_create!(name: 'Sample Club')
  coach.update!(club: club)
end

normal_role = Role.find_or_create_by!(name: 'normal')

{
  'athlete1@example.com' => ['Atleta', 'Uno'],
  'athlete2@example.com' => ['Atleta', 'Dos']
}.each do |email, names|
  athlete = User.find_or_create_by!(email: email) do |u|
    u.google_id = SecureRandom.uuid
    u.role = normal_role
    u.club = coach.club
    u.build_profile(first_name: names[0], last_name: names[1])
  end

  Coaching.find_or_create_by!(coach: coach, athlete: athlete)
end

puts "Athletes created for #{coach.email}."
