# docker-laravel5.4
Laravel framework version 5.4 in a dockerized LAMP stack.

----

## Quickstart
Clone this repo, cd into it's directory, and run `$ sudo ./start.sh`
Once the start script has completed, the stack is up and running.
Open a web browser, and navigate to your local ip address.

## Stopping and Restarting
To stop the docker network and bring the stack down:
`$ docker-compose down`

To restart the docker network and bring the stack up:
`$ docker-compose up -d`

## The Laravel
[https://github.com/laravel/laravel.git](https://github.com/laravel/laravel.git)

## The Stack
| Software          | Version       |
| ----------------- |:-------------:|
| Linux: Debian     | v. Jessie     |
| Apache Web Server | v. 2.4.25     |
| MySQL             | v. 5.7.17     |
| PHP               | v. 7.0        |

## The Support
| Software          | Version       |
| ----------------- |:-------------:|
| Composer          | v. 1.3.1      |
| NodeJS            | v. 6.10.1     |

