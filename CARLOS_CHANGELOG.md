## Latest : v0.9.16

## v0.9.16 – Update to CARLA 0.9.16

### Major changes

* Align GitHub Actions workflow with the upstream Docker restructuring (Base → Monolith → Release) while keeping the custom multi-image publishing pipeline.
* Provide refreshed Docker build context: dedicated PythonAPI client image and release image health check and use Ubuntu 22.04 base provided by upstream.
* Update release image bootstrap to expose the CARLA Python API directly inside the container shell.

### Minor changes

* Re-introduce `ping.py` to the PythonAPI utilities for container health probing.
* Preserve the aria2 download workaround in `Update.sh` with an opt-in flag.

## v0.9.15 – Initial Release

### Major changes

* Created GitHub workflow and Dockerfile to automatically build Docker images
* Update to Ubuntu 22.04 and Python 3.10 for prerequisites image
* Update to Ubuntu 22.04 and Python 3.10 for release image
* Created `vulkan-base` Dockerfile to replace discontinued `nvidia/vulkan` images used for the release image
* Created `client` Dockerfile to provide PythonAPI client image
* Added health check to release image

### Minor changes

* Added `ping.py` script to PythonAPI to enable health checks
* Fix [aria2](https://aria2.github.io/) related issue
* Fix fbx sdk download by using `curl` instead of `wget`
