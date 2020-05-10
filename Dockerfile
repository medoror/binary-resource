FROM ruby:2.7.1-alpine3.11

RUN apk update && apk del wget openssl && apk --no-cache add ca-certificates wget openssl

# Setup and run tests
COPY src/ /opt/resource/src
COPY spec/ /opt/resource/spec
COPY vendor/ /opt/resource/vendor
COPY Gemfile /opt/resource/Gemfile

WORKDIR /opt/resource
RUN bundle install --local
RUN bundle exec rspec .

# Setup and run concourse scripts
COPY src/check.rb /opt/resource/check
COPY src/in.rb /opt/resource/in
COPY src/out.rb /opt/resource/out

COPY src/payload.rb /opt/resource/
COPY src/http_client.rb /opt/resource/

RUN chmod +x /opt/resource/check /opt/resource/in /opt/resource/out

RUN /opt/resource/in
RUN /opt/resource/out
RUN /opt/resource/check