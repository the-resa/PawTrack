# README

Necessary steps to get the application up and running.

## Setup
Ensure you have Docker and Docker Compose installed on your system.
Also node and npm are necessary to execute commands from `package.json` file.

Build the docker container and start the application:

`npm start`

API should now be accessible at:

[http://localhost:3000](http://localhost:3000)


## Testing

Connect to the running container (and from there run tests or curl / redis commands):

`npm run t`

Run tests:

`rspec`

Run curl commands:

`curl http://localhost:3000/up` Please find more API usage examples in the controller `Api::V1::PetsController`.

Connect to redis:

`rails c` and issue commands like `REDIS.keys`

Seed redis database:

`rails db:seed`