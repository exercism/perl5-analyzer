FROM perl:5.42.2-bookworm AS modules

COPY cpanfile /tmp/cpanfile
RUN cpm install -g --cpanfile /tmp/cpanfile --snapshot /dev/null

FROM perl:5.42.2-slim-bookworm

COPY --from=modules /usr/local /usr/local

WORKDIR /opt/analyzer
COPY . .

ENTRYPOINT ["/opt/analyzer/bin/run.sh"]
