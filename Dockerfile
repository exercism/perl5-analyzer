FROM perl:5.44.0-bookworm AS modules

COPY cpanfile /tmp/cpanfile
RUN cpm install -g --cpanfile /tmp/cpanfile --snapshot /dev/null

FROM perl:5.44.0-slim-bookworm@sha256:144ff6766e92184503f25ec36e6dfd0a512477382da8086d5860d66d89f042d3

COPY --from=modules /usr/local /usr/local

WORKDIR /opt/analyzer
COPY . .

ENTRYPOINT ["/opt/analyzer/bin/run.sh"]
