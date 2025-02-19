class Api::V1::PetsController < ApplicationController

  # TODO: instead of `render json` a serializer like [jbuilder](https://github.com/rails/jbuilder) should be used
  # TODO: implement `show` to query a single pet by id or owner_id

  # curl -X GET "http://localhost:3000/api/v1/pets"
  #
  def index
    @pets = Pet.all

    render json: @pets
  end

  # curl -X POST "http://localhost:3000/api/v1/pets" -H "Content-Type: application/json" -d '{"pet": {"pet_type": "Dog", "tracker_type": "big", "owner_id": 1, "in_zone": true, "lost_tracker": false}}'
  # curl -X POST "http://localhost:3000/api/v1/pets" -H "Content-Type: application/json" -d '{"pet": {"pet_type": "Cat", "tracker_type": "small", "owner_id": 2, "in_zone": true, "lost_tracker": true}}'
  #
  def create
    @pet = Pet.new(pet_params)
    @pet.id = SecureRandom.uuid

    if @pet.save
      render json: @pet, status: :created
    else
      render json: @pet.errors, status: :unprocessable_entity
    end
  end

  # curl -X GET "http://localhost:3000/api/v1/pets/outside_zone"
  #
  def outside_zone
    @pets = Pet.outside_power_saving_zone

    render json: @pets
  end

  private

  def pet_params
    params.require(:pet).permit(:owner_id, :pet_type, :tracker_type, :in_zone, :lost_tracker)
  end

end
