# UBlueOS — Justfile for local builds
# Based on ublue-os/image-template Justfile

IMAGE_NAME         := ""
DEFAULT_TAG        := "latest"
BIB_IMAGE          := "quay.io/centos-bootc/bootc-image-builder:latest"

# Load env if present
image-template.env: import? := "image-template.env"

if ! IMAGE_NAME != "" && IMAGE_NAME == "" {
  IMAGE_NAME := image_template.env.IMAGE_NAME
}

# Returns the image name
image_name:
  echo {{IMAGE_NAME}}

# Generates a default tag based on date
generate-default-tag:
  echo {{DEFAULT_TAG}}

# Build the image locally
build target_image=IMAGE_NAME tag=DEFAULT_TAG:
  sudo podman build \
    --build-arg BASE_IMAGE=ghcr.io/ublue-os/bazzite-dx:stable \
    -t {{target_image}}:{{tag}} \
    .

# Build NVIDIA variant locally
build-nvidia target_image=IMAGE_NAME tag=DEFAULT_TAG:
  sudo podman build \
    --build-arg BASE_IMAGE=ghcr.io/ublue-os/bazzite-dx-nvidia-open:stable \
    -t {{target_image}}:{{tag}}-nvidia \
    .

# Rechunk with rpm-ostree for smaller deltas
ostree-rechunk target_image=IMAGE_NAME tag=DEFAULT_TAG:
  rpm-ostree cli rechunk {{target_image}}:{{tag}}

# Build and run a QCOW2 VM for testing
build-qcow2 target_image=IMAGE_NAME tag=DEFAULT_TAG:
  sudo podman run --rm -it \
    --privileged \
    --pull=newer \
    --security-opt label=type:unconfined_t \
    -v /var/lib/containers/storage:/var/lib/containers/storage \
    {{BIB_IMAGE}} \
    --type qcow2 \
    --local {{target_image}}:{{tag}}

# Check Justfile syntax
check:
  just --fmt --check

# Fix Justfile formatting
fix:
  just --fmt --yes

# Clean build artifacts
clean:
  sudo podman image rm -f {{IMAGE_NAME}} 2>/dev/null || true
