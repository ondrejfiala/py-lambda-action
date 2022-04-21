FROM python:3.10-alpine

RUN apt-get update
RUN apt-get install -y jq zip git openssh-client
RUN pip install awscli

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
