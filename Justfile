# UBlueOS — Justfile for CI and local builds
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

# Generates a default tag
generate-default-tag:
  echo {{DEFAULT_TAG}}

# Build the image locally
# Usage: just build <image_name> <tag> [base_image]
build target_image=IMAGE_NAME tag=DEFAULT_TAG base="ghcr.io/ublue-os/bazzite-dx:stable":
  sudo podman build \
    --build-arg BASE_IMAGE={{base}} \
    --label="containers.bootc=1" \
    -t {{target_image}}:{{tag}} \
    .

# Tag the image with additional aliases
# Usage: just tag-images <image_name> <source_tag> <alias_tags>
tag-images target_image=IMAGE_NAME source_tag=DEFAULT_TAG alias_tags="":
  podman tag {{target_image}}:{{source_tag}} {{target_image}}:{{alias_tags}}

# Generate build tags (comma-separated)
generate-build-tags target_image=IMAGE_NAME base_tag=DEFAULT_TAG:
  DATE_TAG=$(date -u +%Y%m%d)
  echo "{{target_image}}:{{base_tag}}-${DATE_TAG},{{target_image}}:{{base_tag}}"

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
