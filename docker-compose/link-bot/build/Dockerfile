FROM alpine:3.17

ARG VERSION_LINK_BOT

RUN \
    apk add python3 py3-pip wget \
    && wget -O link-bot.tar.gz https://github.com/lenormf/link-bot/archive/refs/tags/${VERSION_LINK_BOT}.tar.gz \
    && tar xf link-bot.tar.gz \
    && rm link-bot.tar.gz \
    && mv link-bot-*.* /link_bot/

RUN \
    apk add gcc musl-dev python3-dev libxml2-dev libxslt-dev libxml2 libxslt \
    && cd /link_bot \
    && pip3 install -r requirements.txt \
    && apk del gcc musl-dev python3-dev libxml2-dev libxslt-dev \
    && rm -rf /var/cache/apk/

ENV PYTHONPATH /link_bot
CMD ["irc3", "-d", "/link_bot.cfg"]
