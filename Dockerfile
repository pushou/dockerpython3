FROM debian:latest
MAINTAINER Jean-marc Pouchoulon <jean-marc.pouchoulon@iutbeziers.fr>

# https://github.com/docker-library/python/issues/13
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN echo "deb http://debian.iutbeziers.fr/debian/ jessie main"  > /etc/apt/sources.list

# Update package lists and install python3, python3-dev, pip-3.2
RUN apt-get update && apt-get install --no-install-recommends -y -q \
    python3 \
    python3-dev \ 
    python3-pip \
    python-dev \
    vim \
    vim-python-jedi \
    build-essential \
    libncurses5-dev \
    libncursesw5-dev \
    libz-dev \
    libreadline-dev \
    libncursesw5-dev \
    libssl-dev \
    libgdbm-dev \
    libsqlite3-dev \
    libbz2-dev \
    libzmq3 \
    libzmq3-dev \
    liblzma-dev \
    man \
    ca-certificates \
    git-core \
    locales \
    cmake \
    && rm -rf /var/lib/apt/lists/*
RUN pip3 install jupyter

ENV LANGUAGE=fr_FR:fr
ENV LC_TIME=fr_FR.UTF-8
ENV LC_COLLATE=fr_FR.UTF-8
RUN locale-gen fr_FR fr_FR.UTF-8 
RUN echo "Europe/Paris" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata && \
    sed -i -e 's/# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="fr_FR.UTF-8"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=fr_FR.UTF-8
RUN git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

COPY ./myvimrc /root/.vimrc
RUN vim +PluginInstall +qall
RUN cd /.vim/bundle/YouCompleteMe && ./install.sh --clang-completer
COPY ./python-template.py /root/python_template.py


EXPOSE 8888
ENTRYPOINT cd; /bin/bash
