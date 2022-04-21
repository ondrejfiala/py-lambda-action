FROM python:3.9

RUN apt-get update
RUN apt-get install -y jq zip git/testing openssh-client
RUN pip install awscli

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
