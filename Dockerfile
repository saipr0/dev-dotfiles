FROM debian:trixie-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV MISE_INSTALL_PATH=/usr/local/bin/mise
ENV PATH=/home/dev/.local/bin:/home/dev/.local/share/mise/shims:$PATH

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    apt-transport-https \
    bat \
    build-essential \
    ca-certificates \
    curl \
    eza \
    fd-find \
    fzf \
    git \
    gnupg \
    jq \
    lazygit \
    less \
    libffi-dev \
    libgdbm-dev \
    libncurses-dev \
    libpq-dev \
    libreadline-dev \
    libssl-dev \
    libyaml-dev \
    locales \
    neovim \
    openssh-client \
    pkg-config \
    postgresql-client \
    redis-tools \
    ripgrep \
    shellcheck \
    stow \
    sudo \
    tmux \
    unzip \
    xclip \
    xz-utils \
    zip \
    zlib1g-dev \
    zoxide \
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

RUN useradd --create-home --shell /bin/zsh dev \
  && usermod -aG root dev \
  && echo "dev ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/dev \
  && chmod 0440 /etc/sudoers.d/dev \
  && mkdir -p /workspace \
  && chown -R dev:dev /workspace

USER dev
WORKDIR /home/dev/dev-dotfiles

COPY --chown=dev:dev . /home/dev/dev-dotfiles

RUN ./stow
RUN mise trust ~/.config/mise/config.toml && mise install

WORKDIR /workspace

CMD ["zsh"]
