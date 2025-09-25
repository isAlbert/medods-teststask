FROM ruby:3.3.9

ENV INSTALL_PATH=/opt/app

RUN addgroup --system appgroup &&  \
    adduser --system --ingroup appgroup appuser

RUN mkdir -p $INSTALL_PATH && \
    gem install rails bundler

WORKDIR $INSTALL_PATH
COPY . .

RUN chmod +x bin/docker-setup && \
    bin/docker-setup &&  \
    chown -R appuser:appgroup $INSTALL_PATH


USER appuser
EXPOSE 3000
CMD rails db:migrate &&  \
    rails server -b 0.0.0.0
