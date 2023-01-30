FROM ghcr.io/stake-house/decentralizedgraffitidrawing:latest AS drawer

FROM alpine

COPY --from=drawer /go/bin/drawer /drawer
COPY entrypoint.sh /entrypoint.sh

RUN apk add bash

ENTRYPOINT ["/entrypoint.sh"]
