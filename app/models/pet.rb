class Pet
  include ActiveModel::Model

  # TODO: Lost_tracker attribute should be in a separate model class for cats
  attr_accessor :pet_type, :tracker_type, :owner_id, :in_zone, :lost_tracker, :id

  # TODO: add more validations
  # TODO: use an enum for pet_type and tracker_type instead of magic strings
  validates :pet_type, inclusion: { in: %w(Cat Dog), message: "%{value} is not a valid pet type" }
  validates :tracker_type, inclusion: { in: %w(small medium big), message: "%{value} is not a valid tracker type" }

  validate :lost_tracker_only_for_cats

  # Get all pets from redis.
  def self.all
    all_pets = REDIS.keys("pet:*").flat_map { |key| REDIS.hvals(key) }
    all_pets.map { |pet| JSON.parse(pet) }
  end

  # Get all pets which are outside the power saving zone.
  # TODO: group by pet type and tracker type
  def self.outside_power_saving_zone
    all_pets = REDIS.keys("pet:*").flat_map { |key| REDIS.hvals(key) }
    all_pets.map { |pet| JSON.parse(pet) }.select { |pet| !pet['in_zone'] }
  end

  def save
    return false unless valid?

    REDIS.hset("pet:#{owner_id}", id, to_json)
  end

  def to_json(*_args)
    {
      pet_type: pet_type,
      tracker_type: tracker_type,
      owner_id: owner_id,
      in_zone: in_zone,
      lost_tracker: lost_tracker
    }.to_json
  end

  private

  def lost_tracker_only_for_cats
    if lost_tracker && pet_type != 'Cat'
      errors.add(:lost_tracker, 'can only be true for cats')
    end
  end
end