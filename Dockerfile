FROM debian:trixie-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV MISE_INSTALL_PATH=/usr/local/bin/mise
ENV PATH=/home/saipr/.local/bin:/home/saipr/.local/share/mise/shims:$PATH

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    apt-transport-https \
    build-essential \
    ca-certificates \
    curl \
    git \
    gnupg \
    jq \
    less \
    libffi-dev \
    libgdbm-dev \
    libncurses-dev \
    libpq-dev \
    libreadline-dev \
    libssl-dev \
    libyaml-dev \
    locales \
    openssh-client \
    pkg-config \
    postgresql-client \
    redis-tools \
    stow \
    sudo \
    tmux \
    unzip \
    xclip \
    xz-utils \
    zip \
    zlib1g-dev \
    zsh \
  && rm -rf /var/lib/apt/lists/*

RUN install -m 0755 -d /etc/apt/keyrings \
  && curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc \
  && chmod a+r /etc/apt/keyrings/docker.asc \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian trixie stable" >/etc/apt/sources.list.d/docker.list \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    docker-ce-cli \
    docker-compose-plugin \
  && rm -rf /var/lib/apt/lists/*

RUN curl https://mise.run | sh

RUN useradd --create-home --shell /bin/zsh saipr \
  && usermod -aG root saipr \
  && echo "saipr ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/saipr \
  && chmod 0440 /etc/sudoers.d/saipr \
  && mkdir -p /workspace \
  && chown -R saipr:saipr /workspace

USER saipr
WORKDIR /home/saipr/dev-dotfiles

COPY --chown=saipr:saipr . /home/saipr/dev-dotfiles

RUN stow --no-folding --target="$HOME" zsh tmux nvim mise
RUN mise trust ~/.config/mise/config.toml && mise install

WORKDIR /workspace

CMD ["zsh"]
