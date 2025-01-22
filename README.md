# Mood Tracker Backend

- App has been containerized in docker image using file `Dockerfile`
- A MySQL container included
- Both the App and MySQL have been wrapper in `docker-compose.yml`
- rspec for testing. Testing code in folder `spec`
- DB schema in folder `db`. Check out `migrate`, `schema.db` and `seeds.rb`

## How to start the applications
### App
- run `docker-compose build`
- run `docker-compose up`

### Run test (rspec)
- run `RAILS_ENV=test rails db:create`
- run `rspec`

### What can be improved
- Security: CSRF, XSS and more (OWASP Top 10)
- Integration test for Controllers, and better test coverage (Test)
- CI/CD and Observability, etc. (DevOps)