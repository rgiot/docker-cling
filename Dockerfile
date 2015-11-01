FROM ubuntu:15.04

MAINTAINER Tom <tmbdev@gmail.com>
ENV DEBIAN_FRONTEND noninteractive
ENV PATH /usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:.

# Install necessary packages for cling
RUN apt-get update && \
    apt-get upgrade && \
    apt-get -y install \
    	apt-utils  \
	git  \
	curl  \
	wget  \
	unzip  \
	git-core  \
	build-essential  \
	gcc  \
	g++  \
	cmake  \
	gdb  \
	libreadline-dev  \
	python  \
	groff  

# Get and compile cling
WORKDIR /tmp
RUN git clone http://root.cern.ch/git/llvm.git src
WORKDIR /tmp/src
RUN git checkout cling-patches
WORKDIR /tmp/src/tools
RUN git clone http://root.cern.ch/git/cling.git
RUN git clone http://root.cern.ch/git/clang.git
WORKDIR /tmp/src/tools/clang
RUN git checkout cling-patches
WORKDIR /tmp/src
RUN ./configure --enable-cxx11
RUN make
RUN make install

RUN apt-get -qqy install python-pip
RUN apt-get -qqy install libzmq3-dev libcurl4-openssl-dev
RUN apt-get -qqy install python-dev
RUN apt-get -qqy install cython
RUN pip install ipython[notebook]
RUN apt-get -qqy install libeigen3-dev

# This isn't quite working yet because clingkernel is written
# to a newer API than what pip install ipython[notebook] installs.
#WORKDIR /tmp
#RUN git clone https://github.com/minrk/clingkernel.git
#RUN cd clingkernel && python setup.py install
#RUN pip install ipython-extensions
#RUN pip install ipython-helpers
#RUN pip install metakernel
#ADD logo-64x64.png /usr/local/lib/python2.7/dist-packages/metakernel/images/logo-64x64.png
#ADD logo-32x32.png /usr/local/lib/python2.7/dist-packages/metakernel/images/logo-32x32.png
#RUN pip install metakernel_bash
#RUN pip install metakernel_python
#RUN cd clingkernel && ipython kernelspec install cling

EXPOSE 8888
