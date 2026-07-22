# UBlueOS — Bazzite-DX + MangoWM + Noctalia v5
#
# Matrix build: two variants from the same scripts.
#   ghcr.io/patrikhallgren/ublueos:stable        — AMD/Intel (bazzite-dx)
#   ghcr.io/patrikhallgren/ublueos:stable-nvidia — NVIDIA   (bazzite-dx-nvidia-open)
#
# Build arg selects the base. GitHub Actions sets it via matrix.

ARG BASE_IMAGE=ghcr.io/ublue-os/bazzite-dx:stable

FROM ${BASE_IMAGE}

# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /

# Terra is pre-enabled on Bazzite — good, we need it for mangowm, noctalia, fonts

### === Phase 1: Base system tweaks ===
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/00-base.sh

### === Phase 2: Applications (browsers, PIA, pCloud, etc.) ===
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/10-apps.sh

### === Phase 3: Developer tooling ===
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/20-dev-tools.sh

### === Phase 4: Cleanup ===
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/30-cleanup.sh

### === System files — dropped in place for all users ===
COPY system_files /

### === User services — first-login setup, etc. ===
COPY services /usr/lib/systemd/user/

### === Enable first-login service for new users ===
RUN systemctl --global enable ublueos-first-login.service 2>/dev/null || true

### === Linting ===
RUN bootc container lint
