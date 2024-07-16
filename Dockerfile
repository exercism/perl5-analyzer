FROM perl:5.40.0-slim-bookworm

RUN apt-get update && \
    apt-get install -y curl build-essential && \
    apt-get purge --auto-remove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt/analyzer
COPY . .
RUN curl -fsSL https://raw.githubusercontent.com/skaji/cpm/main/cpm | perl - install -g --cpanfile /opt/analyzer/cpanfile --snapshot /dev/null

ENTRYPOINT ["/opt/analyzer/bin/run.sh"]
