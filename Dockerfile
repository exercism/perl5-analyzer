FROM perl:5.42.2-bookworm AS modules

COPY cpanfile /tmp/cpanfile
RUN cpm install -g --cpanfile /tmp/cpanfile --snapshot /dev/null

FROM perl:5.42.2-slim-bookworm@sha256:49f4e5e7e2fc5b12e5fc9b5a0603d96502feb24b97babd1bdf42e3f1fc3ebc43

COPY --from=modules /usr/local /usr/local

WORKDIR /opt/analyzer
COPY . .

ENTRYPOINT ["/opt/analyzer/bin/run.sh"]
