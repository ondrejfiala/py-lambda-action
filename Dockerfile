FROM continuumio/miniconda3:4.10.3-alpine

RUN apk update
RUN apk add jq zip bash git
RUN pip install awscli

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
