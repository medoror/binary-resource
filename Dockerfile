FROM ruby:2.7.1-alpine

COPY src/check.rb /opt/resource/check
COPY src/in.rb /opt/resource/in
COPY src/out.rb /opt/resource/out
COPY Gemfile /opt/resource/Gemfile
COPY vendor/ /opt/resource/vendor

RUN chmod +x /opt/resource/check /opt/resource/in /opt/resource/out

WORKDIR /opt/resource
RUN bundle install --local

RUN /opt/resource/in
RUN /opt/resource/out
RUN /opt/resource/check