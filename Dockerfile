# Use an official Ruby image as a base
FROM ruby:3.2.2

# Set working directory
WORKDIR /app

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    libssl-dev \
    libreadline-dev \
    libyaml-dev \
    nodejs \
    yarn

# Install bundler
RUN gem install bundler

# Copy files
COPY Gemfile Gemfile.lock ./
RUN bundle config set --global force_ruby_platform true
RUN bundle install
COPY . .

EXPOSE 3000

# Default command for Rails
CMD bundle exec rails db:migrate && \
    bundle exec rails db:seed && \
    bundle exec rails server -b '0.0.0.0' -e development
