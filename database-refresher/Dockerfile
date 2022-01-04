# syntax=docker/dockerfile:1
FROM yandex/clickhouse-client

RUN apt-get update && apt-get -y install python3 curl cron && \
    mkdir /var/lib/harvester

ADD harvester.sh /harvester.sh
ADD owid_cleaner.py /bin/owid_cleaner
RUN chmod u+x /harvester.sh /bin/owid_cleaner

ADD harvester-cron /etc/crontab

ENTRYPOINT ["cron", "-f"]
