FROM perl:5.44.0-bookworm AS modules

COPY cpanfile /tmp/cpanfile
RUN cpm install -g --cpanfile /tmp/cpanfile --snapshot /dev/null

FROM perl:5.44.0-slim-bookworm@sha256:7bb4f7451267b9cd9e433bb23097ab3ace555afa4ac1ecbda8776b4a742385b0

COPY --from=modules /usr/local /usr/local

WORKDIR /opt/analyzer
COPY . .

ENTRYPOINT ["/opt/analyzer/bin/run.sh"]
