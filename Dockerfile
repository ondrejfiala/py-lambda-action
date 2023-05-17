FROM continuumio/miniconda3:23.3.1-0

RUN apk update
RUN apk add jq zip bash git
RUN pip install awscli

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
