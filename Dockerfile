FROM python:3
WORKDIR /usr/src/app
MAINTAINER Belen Nazareth Duran "belennazareth29@gmail.com"
RUN pip install --root-user-action=ignore --upgrade pip && pip install --root-user-action=ignore django mysqlclient 
COPY * /usr/src/app 
RUN mkdir static
ADD polls.sh /usr/src/app/
RUN chmod +x /usr/src/app/polls.sh
ENTRYPOINT ["/usr/src/app/polls.sh"]
