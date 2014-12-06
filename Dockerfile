FROM debian:jessie

MAINTAINER Learning Docker <jimmy.huang@learningdocker.com>

RUN apt-get update && apt-get install -qy \
 curl \
 git \
 libpq-dev \
 libprocps3 \
 libprocps3-dev \
 nodejs \
 postgresql \
 procps

# Install RVM, Ruby 2.1.2, and the Bundler gem
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
RUN curl -sSL https://get.rvm.io | bash -s stable
RUN ["/bin/bash", "-l", "-c", "rvm requirements; rvm install 2.1.2; gem install bundler --no-ri --no-rdoc"]

# Run `bundle install` BEFORE adding the Rails application directory structure
# to /app on the container's filesystem.
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

WORKDIR /app

RUN ["/bin/bash", "-l", "-c", "bundle install"]

# Add the Rails application directory structure to /app on the container's filesystem
ADD . /app

# Open port 3000 on the container
EXPOSE 3000

# Overridable startup commands
CMD ["/app/bin/start-server"]
