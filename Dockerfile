FROM postgres:15.0

WORKDIR /app

COPY run.sh run.sh
COPY mc /usr/local/bin/mc
COPY go-cron /usr/local/bin/go-cron
COPY backup.sh backup.sh
RUN chmod +x  /usr/local/bin/mc && chmod +x /usr/local/bin/go-cron

CMD ["sh", "run.sh"]
