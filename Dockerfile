FROM ubuntu:16.04

LABEL maintainer="Jaeyoung Chun (jaeyoung.chun@weizmann.ac.il)"

ENV LOBSTR_VERSION="4.0.6"

# install dependencies required for lobSTR
# pyfast, numpy are required for scripts/lobstr_index.py, scripts/GetSTRInfo.py
RUN apt-get update -y \
    && apt-get install -y wget build-essential pkg-config libgsl-dev zlib1g-dev libboost-all-dev libcppunit-dev \
    && apt-get install -y python-pip \
    && pip install --upgrade pip \
    && pip install pyfasta==0.5.2 numpy==1.13.3

WORKDIR /tmp

# build/install lobstr
RUN wget https://github.com/mgymrek/lobstr-code/releases/download/v${LOBSTR_VERSION}/lobSTR-${LOBSTR_VERSION}.tar.gz \
    && tar xvzf lobSTR-${LOBSTR_VERSION}.tar.gz \
    && cd lobSTR-${LOBSTR_VERSION} \
    && ./configure \
    && make \
    && make check \
    && make install

WORKDIR /root
ENTRYPOINT ["/usr/local/bin/lobSTR"]
CMD ["--help"]
