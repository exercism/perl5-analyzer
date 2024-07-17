FROM perl:5.40.0-bookworm AS modules

COPY cpanfile /tmp/cpanfile
RUN cpm install -g --cpanfile /tmp/cpanfile --snapshot /dev/null

FROM perl:5.40.0-slim-bookworm

COPY --from=modules /usr/local /usr/local

WORKDIR /opt/analyzer
COPY . .

ENTRYPOINT ["/opt/analyzer/bin/run.sh"]
