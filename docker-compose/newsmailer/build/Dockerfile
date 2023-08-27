FROM alpine:3.15

ARG VERSION_NEWSBOAT_SENDMAIL
ARG VERSION_SENDMAIL_TRYQUEUE
ARG VERSION_NEWS2RSS

RUN \
    apk add newsboat python3 py3-pip wget

RUN \
    wget -O newsboat-sendmail.tar.gz https://github.com/lenormf/newsboat-sendmail/archive/refs/tags/${VERSION_NEWSBOAT_SENDMAIL}.tar.gz \
    && tar xf newsboat-sendmail.tar.gz \
    && rm newsboat-sendmail.tar.gz

RUN \
    cd newsboat-sendmail-* \
    && pip3 install -r requirements.txt \
    && install -m 0755 newsboat-sendmail.py /usr/bin/newsboat-sendmail \
    && cd - \
    && rm -r newsboat-sendmail-*

RUN \
    wget -O sendmail-tryqueue.tar.gz https://github.com/lenormf/sendmail-tryqueue/archive/refs/tags/${VERSION_SENDMAIL_TRYQUEUE}.tar.gz \
    && tar xf sendmail-tryqueue.tar.gz \
    && rm sendmail-tryqueue.tar.gz

RUN \
    cd sendmail-tryqueue-* \
    && apk add msmtp \
    && install -m 0755 sendmail-tryqueue.py /usr/bin/sendmail-tryqueue \
    && cd - \
    && rm -r sendmail-tryqueue-*

RUN \
    wget -O news2rss.tar.gz https://github.com/lenormf/news2rss/archive/refs/tags/${VERSION_NEWS2RSS}.tar.gz \
    && tar xf news2rss.tar.gz \
    && rm news2rss.tar.gz

RUN \
    cd news2rss-* \
    && apk add gcc musl-dev python3-dev libxml2-dev libxslt-dev libxml2 libxslt \
    && pip3 install -r requirements.txt \
    && install -m 0755 news2rss.py /usr/bin/news2rss \
    && cd - \
    && rm -r news2rss-* \
    && apk del gcc musl-dev python3-dev libxml2-dev libxslt-dev \
    && mkdir /etc/newsapi

COPY newsapi.sh /etc/newsapi/

RUN \
    rm -rf /var/cache/apk/

COPY entrypoint.sh /

CMD ["/entrypoint.sh"]
