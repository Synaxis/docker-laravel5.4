#!/usr/bin/env bash

# Clone in the Laravel 5.4 repo from GitHub
git clone https://github.com/laravel/laravel.git

# Rename the repo
sudo mv ./laravel/ ./html/

# Copy the .env file into the root of Laravel
sudo cp ./server_config/.env ./html/.env

# Extract the base MySQL database into the directory, then cleanup file
sudo tar -xvzf ./mysql.tar.gz
sudo rm -f ./mysql.tar.gz

# Build the image the first time by running up the container via Docker-Compose
docker-compose up -d

# Install the composer dependencies
docker exec -it laravel_server composer install

# Generate an application key
docker exec -it laravel_server php artisan key:generate

# Open all permissions on the install for development purposes
sudo chmod -R 0777 ./html

# Cleanup the directory
sudo rm -Rf ./server_config
sudo rm -f ./start.sh
sudo rm -f ./Dockerfile
sudo rm -f ./README.md

# Output notification that processes are complete                  
echo "Build Complete. Load http://your.local.ip.address into your web browser."

