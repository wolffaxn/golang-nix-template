FROM nixos/nix:latest AS builder

COPY . /tmp/build
WORKDIR /tmp/build

RUN nix --extra-experimental-features "nix-command flakes" build

RUN mkdir -p /tmp/nix/store
RUN cp -R $(nix-store -qR result/) /tmp/nix/store

FROM scratch

ARG BUILD_DATE
ARG VCS_REF
ARG VCS_URL

# metadata
LABEL org.opencontainers.image.authors="Alexander Wolff <wolffaxn@gmail.com>" \
  org.opencontainers.image.created=${BUILD_DATE} \
  org.opencontainers.image.revision=${VCS_REF} \
  org.opencontainers.image.source=${VCS_URL}

WORKDIR /

COPY --from=builder /tmp/nix/store /nix/store
COPY --from=builder /tmp/build/result /

CMD ["/bin/hello"]
