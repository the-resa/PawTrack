require 'rails_helper'
require 'ostruct'

RSpec.describe "Api::V1::Pets", type: :request do
  before(:each) do
    REDIS.flushdb # TODO: check if redis store for test env is used correctly
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
end
