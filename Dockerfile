FROM ondrejfiala/bootstrap:2.1.4
#FROM continuumio/miniconda3:23.3.1-0-alpine

RUN apk update
RUN apk add jq zip bash git
RUN pip install awscli

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
