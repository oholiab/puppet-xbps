FROM void
RUN xbps-install -y puppet ruby-devel git make gcc libgcc
ADD ./Gemfile /Gemfile
RUN gem install bundler
RUN bundle install
CMD cd /test && bundle exec rake dacceptance
