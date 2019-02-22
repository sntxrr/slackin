FROM node:slim
ENV PORT 3000
ADD . /srv/www
WORKDIR /srv/www

RUN curl -L -o /bin/aws-env https://github.com/Droplr/aws-env/raw/master/bin/aws-env-linux-amd64 && \
    chmod +x /bin/aws-env

RUN npm install --unsafe-perm
EXPOSE 3000

COPY secrets-entrypoint.sh /secrets-entrypoint.sh
COPY blockdomains.txt /blockdomains.txt
ENTRYPOINT ["/bin/bash", "-c", "eval $(/bin/aws-env) && /secrets-entrypoint.sh"]

CMD ./bin/slackin --coc "$SLACK_COC" --channels "$SLACK_CHANNELS" --port $PORT $SLACK_SUBDOMAIN $SLACK_API_TOKEN $GOOGLE_CAPTCHA_SECRET $GOOGLE_CAPTCHA_SITEKEY
