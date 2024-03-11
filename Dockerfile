FROM continuumio/miniconda3:24.1.2-0
#FROM continuumio/miniconda3:23.3.1-0-alpine

RUN apk update
RUN apk add jq zip bash git
RUN pip install awscli

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
