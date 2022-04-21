FROM frolvlad/alpine-miniconda3

RUN apk update
RUN apk add git openssh 
RUN apk add jq zip bash
RUN pip install awscli

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
