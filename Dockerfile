FROM ubuntu:15.10

RUN apt-get update
RUN apt-get install -y ruby=1:2.1.5.1ubuntu1 #=1:2.3.0+1
RUN apt-get install -y python=2.7.9-1 #=2.7.11-1
RUN apt-get install -y php5=5.6.11+dfsg-1ubuntu3.1 # 1:7.0+35ubuntu6
RUN apt-get install -y make
RUN apt-get install -y wget
RUN apt-get install -y python-pip
RUN pip install virtualenv
RUN gem install bundle

COPY . /src

#clean only matters when building locally (not from a fresh checkout)
#if something has not made it into docker ignore
CMD cd /src; make clean; make test
