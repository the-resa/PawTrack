require 'rails_helper'
require 'ostruct'

RSpec.describe Pet, type: :model do
  describe 'validation: pet_type' do
    it 'is valid with a pet_type of Cat' do
      pet = Pet.new(pet_type: 'Cat', in_zone: true, tracker_type: 'small', lost_tracker: false)
      expect(pet).to be_valid
    end

    it 'is valid with a pet_type of Dog' do
      pet = Pet.new(pet_type: 'Dog', in_zone: true, tracker_type: 'medium', lost_tracker: false)
      expect(pet).to be_valid
    end

    it 'is not valid with a pet_type other than Cat or Dog' do
      pet = Pet.new(pet_type: 'Horse', in_zone: false, tracker_type: 'small', lost_tracker: false)
      expect(pet).not_to be_valid
      expect(pet.errors[:pet_type]).to include('Horse is not a valid pet type')
    end
  end

  describe 'validation: lost_tracker' do
    it 'is valid when lost_tracker is true and pet_type is Cat' do
      pet = Pet.new(pet_type: 'Cat', tracker_type: 'small', in_zone: false, lost_tracker: true)
      expect(pet).to be_valid
    end

    it 'is not valid when lost_tracker is true and pet_type is Dog' do
      pet = Pet.new(pet_type: 'Dog', tracker_type: 'medium', in_zone: false, lost_tracker: true)
      expect(pet).not_to be_valid
      expect(pet.errors[:lost_tracker]).to include('can only be true for cats')
    end

    it 'is valid when lost_tracker is false and pet_type is Dog' do
      pet = Pet.new(pet_type: 'Dog', tracker_type: 'medium', in_zone: false, lost_tracker: false)
      expect(pet).to be_valid
    end
  end

  describe '#save' do
    let(:redis) { MockRedis.new }
    before do
      stub_const('REDIS', redis)
    end

    it 'saves the pet to redis' do
      pet = Pet.new(pet_type: 'Cat', tracker_type: 'small', owner_id: 1, in_zone: true, lost_tracker: false)
      allow(pet).to receive(:id).and_return(1)
      pet.save

      saved_pet = JSON.parse(redis.hget("pet:1", '1'), object_class: OpenStruct)
      expect(saved_pet.pet_type).to eq('Cat')
      expect(saved_pet.tracker_type).to eq('small')
      expect(saved_pet.owner_id).to eq(1)
      expect(saved_pet.in_zone).to eq(true)
      expect(saved_pet.lost_tracker).to eq(false)
    end

    it 'does not save the pet to redis if entity is invalid' do
      pet = Pet.new(pet_type: 'Horse', tracker_type: 'big', owner_id: 1, in_zone: true, lost_tracker: false)
      allow(pet).to receive(:id).and_return(1)
      pet.save

      saved_pet = redis.hget("pet:1", '1')
      expect(saved_pet).to be_nil
    end

    describe 'validation: tracker types' do
      it 'is valid with a tracker_type of small' do
        pet = Pet.new(pet_type: 'Cat', tracker_type: 'small', in_zone: false, lost_tracker: false)
        expect(pet).to be_valid
      end

      it 'is valid with a tracker_type of medium' do
        pet = Pet.new(pet_type: 'Dog', tracker_type: 'medium', in_zone: false, lost_tracker: false)
        expect(pet).to be_valid
      end

      it 'is valid with a tracker_type of big' do
        pet = Pet.new(pet_type: 'Dog', tracker_type: 'big', in_zone: false, lost_tracker: false)
        expect(pet).to be_valid
      end

      it 'is not valid with a tracker_type other than small, medium, or big' do
        pet = Pet.new(tracker_type: 'XL')
        expect(pet).not_to be_valid
        expect(pet.errors[:tracker_type]).to include('XL is not a valid tracker type')
      end
    end
  end

end
