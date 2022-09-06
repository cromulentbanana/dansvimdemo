FROM ubuntu:22.04 as builder
LABEL maintainer="Dan Levin <dan@badpacket.in>"

SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8


RUN apt-get update && apt-get install --no-install-recommends -y \
	build-essential \
	ca-certificates \
	cmake \
	curl \
	default-jdk \
	git \
	golang \
	mono-complete \
	nodejs \
	npm \
	python3-dev \
	python3-pip \
	python3-neovim

ADD https://github.com/neovim/neovim/releases/download/v0.7.2/nvim-linux64.deb /tmp/
RUN apt install /tmp/nvim-linux64.deb

RUN groupadd -g 1000 user && \
    useradd -m -r -u 1000 -g user user
RUN chown -R user:user /home/user

USER user

WORKDIR /home/user

RUN mkdir -p ~/.vim
RUN git clone https://github.com/VundleVim/Vundle.vim.git .vim/bundle/Vundle.vim
RUN mkdir -p ~/.config/nvim

COPY .vimrc ./
COPY nvim .config/nvim/

RUN nvim +PluginInstall +qall
RUN cd .vim/bundle/YouCompleteMe/ && python3 install.py --all

COPY backup.py Pipfile Pipfile.lock ./
ENV PATH "~/.local/bin":${PATH}
RUN echo 'export PATH="~/.local/bin":${PATH}' >>~/.bashrc
RUN pip install --user pipenv
RUN pipenv install --dev

USER root
RUN chown -R user:user /home/user
USER user
