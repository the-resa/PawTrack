# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#

pets_data = []

30.times do |i|
  pet_type = ['Dog', 'Cat'].sample
  tracker_type = pet_type == 'Dog' ? ['small', 'medium', 'big'].sample : ['small', 'big'].sample
  lost_tracker = pet_type == 'Cat' ? [true, false].sample : false

  pets_data << {
    owner_id: i + 1,
    pet_type: pet_type,
    tracker_type: tracker_type,
    in_zone: [true, false].sample.to_s,
    lost_tracker: lost_tracker.to_s
  }
end

pets_data.each do |pet_data|
  REDIS.hset("pet:#{pet_data[:owner_id]}", pet_data)
end