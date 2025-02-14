# README

Necessary steps to get the application up and running.


Ensure you have Docker and Docker Compose installed on your system.

```
docker -v
docker-compose -v
```


1. Build and Start the Docker Container

`docker-compose up --build -d`

2. Open a Shell Inside the Container

`docker-compose exec web bash`


3. Install gems

`bundle install`


4. Start the Rails API Server

`rails server -b 0.0.0.0`


API should be accessible at:

[http://localhost:3000](http://localhost:3000)