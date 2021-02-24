# For pure c++ programming
# With Code-Server
# 0.3 with c++
# 0.4 with c++, cmake, java extension pack, mainly for JNI programming

FROM ubuntu:16.04

# the maintainer information
LABEL maintainer "Teng Fu <teng.fu@teleware.com>"

RUN apt-get update --fix-missing && \
    apt-get install -y --no-install-recommends \
        build-essential \
        libcurl3-dev \
        libfreetype6-dev \
        libhdf5-serial-dev \
        libpng12-dev \
        libzmq3-dev \
        libglib2.0-0 \
        libxext6 \
        libsm6 \
        libxrender1 \
        pkg-config \
        python-dev \
        rsync \
        software-properties-common \
        unzip \
        zip \
        zlib1g-dev \
        wget \
        curl \
        git \
        tree \
        iputils-ping \
        bzip2 \
        bash \
        ca-certificates \
        mercurial \
        subversion \
        bsdtar \
        openssl \
        locales \
        net-tools \
        && \
    rm -rf /var/lib/apt/lists/* 


# for NodeJS installation
# ------------------  Node SDK ----------
# according to https://github.com/nodesource/distributions
# target for NodeJS version 10.24

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    nodejs \
    && rm -rf /var/lib/apt/lists/*

# ------------------ Yarn installation ----------

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - 
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install --no-install-recommends -y \
    yarn \
    && rm -rf /var/lib/apt/lists/*

# must be after env installatin
# ------------- Code-Server --------------------

RUN curl -fsSL https://code-server.dev/install.sh | sh -s -- --dry-run
RUN curl -fsSL https://code-server.dev/install.sh | sh

RUN code-server --install-extension mgmcdermott.vscode-language-babel
RUN code-server --install-extension dbaeumer.vscode-eslint
RUN code-server --install-extension esbenp.prettier-vscode
# RUN code-server --install-extension christian-kohler.npm-intellisense
# RUN code-server --install-extension christian-kohler.path-intellisense
RUN code-server --install-extension jawandarajbir.react-vscode-extension-pack
# RUN code-server --install-extension vscode-icons-team.vscode-icons
RUN code-server --install-extension eg2.vscode-npm-script
# RUN code-server --install-extension ms-vscode.vscode-typescript-next
# RUN code-server --install-extension alefragnani.project-manager

# --------------- ngrok -------------
# https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
RUN wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip -P /tmp && \
    unzip /tmp/ngrok-stable-linux-amd64.zip -d /usr/bin && \
    rm -rf /tmp/* 

# ------------------ workspace --------------
# the default volume shared with host machine directory
# in the docker run 
# use docker run -v <absolute path of local folder>:/app
RUN mkdir /app

# workspace directory
WORKDIR /app

# Expose ports
# TensorBoard
# EXPOSE 6006
# IPython
EXPOSE 3000
EXPOSE 8888
EXPOSE 8080
# # React-Native packager
EXPOSE 19000
EXPOSE 19001

# remove watch limit
# COPY watchlimit.sh /
# RUN chmod -R 777 /watchlimit.sh
# developer has two options for reset watch file limit
# 1. on Docker host machine, run all cmdlines in watchlimit.sh with 'sudo'
# this changes the host machine setting, so docker can directly mount the setting
# from host machine.
# 2. when launched in docker container, open Terminal, use following cmd
# /wathlimit.sh
# this cmd changes watch file limit in docker container without effect host machine

# remove watch limit
RUN echo fs.inotify.max_user_watches=524288 | tee -a /etc/sysctl.conf && sysctl -p

# CMD ["code-server", "--auth", "none"]
CMD ["code-server", "--link", "codeserveruser"]