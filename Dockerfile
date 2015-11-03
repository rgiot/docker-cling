FROM ubuntu:15.10

MAINTAINER Tom <tmbdev@gmail.com>
ENV DEBIAN_FRONTEND noninteractive
ENV PATH /usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:.

# Install necessary packages for cling
RUN apt-get update && \
    apt-get -y --force-yes install \
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
	groff  \
	python-pip \      
	python-dev \
	libzmq3-dev \
	python3-all-dev \
	libcurl4-openssl-dev \
	python-cxx-dev

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
RUN ./configure \
	--enable-cxx11 \
	--disable-docs \
	--enable-optimized \
	--disable-assertions \
	--enable-targets=$(dpkg-architecture | grep DEB_TARGET_GNU_CPU | sed -e 's/^.*=//') && \
    make -j4 && \
    make install


RUN pip install tornado && \
	pip install jupyter

# Install cling kernel for ipython
WORKDIR /tmp
RUN git clone https://github.com/minrk/clingkernel.git clingkernel
WORKDIR /tmp/clingkernel
RUN python setup.py install && \
	jupyter kernelspec install cling


EXPOSE 8888
CMD jupyter notebook

