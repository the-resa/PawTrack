require 'rails_helper'
require 'ostruct'

RSpec.describe "Api::V1::Pets", type: :request do
  before(:each) do
    REDIS.flushdb # TODO: check if redis store for test env is used correctly
  end

  describe "GET /index" do
    it "returns a successful response" do
      @pet1 = Pet.new(pet_type: 'Cat', tracker_type: 'small', owner_id: 1, in_zone: true, lost_tracker: false, id: SecureRandom.uuid)
      @pet2 = Pet.new(pet_type: 'Dog', tracker_type: 'medium', owner_id: 2, in_zone: true, lost_tracker: false, id: SecureRandom.uuid)
      @pet1.save
      @pet2.save

      get api_v1_pets_path, as: :json
      expect(response).to have_http_status(:success)

      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(2)
    end
  end

  describe "POST /create" do
    let(:valid_attributes) { { pet_type: "Cat", tracker_type: "small", in_zone: true, lost_tracker: false, owner_id: 1 } }

    it "saves the pet to redis" do
      post api_v1_pets_path, params: { pet: valid_attributes }

      expect(response).to have_http_status(:created)

      last_id = REDIS.hkeys("pet:1").last
      saved_pet = JSON.parse(REDIS.hget("pet:1", last_id), object_class: OpenStruct)
      expect(saved_pet.pet_type).to eq("Cat")
      expect(saved_pet.tracker_type).to eq("small")
      expect(saved_pet.in_zone).to eq("true")
      expect(saved_pet.lost_tracker).to eq("false")
    end
  end

  describe "GET /outside_zone" do
    it "returns a successful response" do
      @pet1 = Pet.new(pet_type: 'Cat', tracker_type: 'small', owner_id: 1, in_zone: false, lost_tracker: false, id: SecureRandom.uuid)
      @pet2 = Pet.new(pet_type: 'Dog', tracker_type: 'medium', owner_id: 2, in_zone: true, lost_tracker: false, id: SecureRandom.uuid)
      @pet3 = Pet.new(pet_type: 'Dog', tracker_type: 'big', owner_id: 3, in_zone: false, lost_tracker: false, id: SecureRandom.uuid)

      @pet1.save
      @pet2.save
      @pet3.save

      get api_v1_pets_outside_zone_path, as: :json
      expect(response).to have_http_status(:success)

      json_response = JSON.parse(response.body)

      expect(json_response.size).to eq(2)
      expect(json_response.map { |pet| pet['owner_id'] }).to include(@pet1.owner_id, @pet3.owner_id)
      expect(json_response.map { |pet| pet['owner_id'] }).not_to include(@pet2.owner_id)
    end

    it "returns an empty array if no pets are outside the zone" do
      get api_v1_pets_outside_zone_path, as: :json
      expect(response).to have_http_status(:success)

      json_response = JSON.parse(response.body)
      expect(json_response).to eq([])
    end
  end
end
