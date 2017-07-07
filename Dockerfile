FROM ubuntu:16.04

RUN mkdir -p /mnt/myapp/current
COPY . /mnt/myapp/current/

#Remove any apt-get data
RUN  rm -rf /var/lib/apt/lists/*

