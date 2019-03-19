FROM ministryofjustice/ruby:2.6.0-webapp-onbuild

# The following are ENV variables that need to be present by the time
# the assets pipeline run, but doesn't matter their value.
#
ENV EXTERNAL_URL    replace_this_at_build_time
ENV SECRET_KEY_BASE replace_this_at_build_time

RUN touch /etc/inittab

RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb http://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    curl -sL https://deb.nodesource.com/setup_10.x | bash -

RUN apt-get update && apt-get install yarn nodejs

ENV RAILS_ENV production
ENV PUMA_PORT 3000

RUN bundle exec rake assets:precompile

ARG APP_BUILD_DATE
ENV APP_BUILD_DATE ${APP_BUILD_DATE}

ARG APP_BUILD_TAG
ENV APP_BUILD_TAG ${APP_BUILD_TAG}

ARG APP_GIT_COMMIT
ENV APP_GIT_COMMIT ${APP_GIT_COMMIT}

EXPOSE $PUMA_PORT
ENTRYPOINT ["./run.sh"]
