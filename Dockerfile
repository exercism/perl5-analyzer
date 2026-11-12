FROM perl:5.44.0-bookworm AS modules

COPY cpanfile /tmp/cpanfile
RUN cpm install -g --cpanfile /tmp/cpanfile --snapshot /dev/null

FROM perl:5.44.0-slim-bookworm@sha256:0b95f4759dc5132c024628458f8b4df469b7e8eb9640e3908ebedb538bd90957

COPY --from=modules /usr/local /usr/local

WORKDIR /opt/analyzer
COPY . .

ENTRYPOINT ["/opt/analyzer/bin/run.sh"]
