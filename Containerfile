# UBlueOS — Bazzite-DX + MangoWM + Noctalia v5
#
# Matrix build: two variants from the same scripts.
#   ghcr.io/patrikhallgren/ublueos:stable        — AMD/Intel (bazzite-dx)
#   ghcr.io/patrikhallgren/ublueos:stable-nvidia — NVIDIA   (bazzite-dx-nvidia)
#
# Build arg selects the base. GitHub Actions sets it via matrix.

ARG BASE_IMAGE=ghcr.io/ublue-os/bazzite-dx:stable

# Context stage: holds build scripts without baking them into layers
FROM scratch AS ctx
COPY build_files /

# Main stage: the actual OS image
FROM ${BASE_IMAGE}

# Copy build scripts into the image so we can run them
COPY --from=ctx / /

# Terra is pre-enabled on Bazzite — good for mangowm, noctalia, fonts

### === Fix /opt (atomic images symlink it to /var/opt, which breaks RPMs) ===
RUN rm /opt && mkdir /opt

### === Phase 1: Base system tweaks ===
RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /00-base.sh

### === Phase 2: Applications (browsers, PIA, pCloud, etc.) ===
RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /10-apps.sh

### === Phase 3: Developer tooling ===
RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /20-dev-tools.sh

### === Phase 4: Cleanup ===
RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /30-cleanup.sh

### === System files ===
COPY system_files /

### === User services ===
COPY services /usr/lib/systemd/user/

### === Enable first-login service ===
RUN systemctl --global enable ublueos-first-login.service 2>/dev/null || true

### === Linting ===
RUN bootc container lint
