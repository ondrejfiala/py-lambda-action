FROM python:3.9

RUN apt-get update
RUN apt-get install -y jq zip git openssh
RUN pip install awscli

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
