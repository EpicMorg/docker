# Support Document for Docker Image Concepts in Project

`timestamp: 2024/08/12`

| Debian | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | sid |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| **codename** | squeeze | wheezy | jessie | stretch | buster | **bullseye** | **bookworm** | trixie | sid |
| **status** | deprecated | deprecated | deprecated | deprecated | deprecated | **LTS** | **Current** | testing | unstable |

## Introduction

The `epicmorg/docker` repository contains a collection of `Docker images `organized by `Debian` versions and used for both base and final product images. The primary goal of this concept is to `ensure organization and relevance of images depending on their use and status`. This document describes the current approach to image organization and planned changes to improve version management and support.

### Image Organization

##### Base Images

In the directory `linux/ecosystem/epicmorg/debian`, Docker images based on various `Debian` versions (from `6` to `12`) are located. All base images can be classified into the following categories:

1. **`slim` Image**:
   - Inherits from official Debian images (versions 6-12).
   - Contains minimal changes: addition of folders, root certificates, and APT configuration.

2. **`main` Image**:
   - Inherits from the `slim` image.
   - Includes a basic set of software (e.g., `mc`, `wget`, `htop`).
   - Intended as a base image for creating more complex final images, such as Nginx.

3. **`develop` Image**:
   - Inherits from the `main` image.
   - Includes build and development tools (e.g., `ninja`, `make`, `cmake`).

4. **`nodejs` Images**:
   - Include Node.js versions (from 0.4 to the latest).
   - Inherit from the `main` image.
   - Contain Node.js, npm, npmx, yarn, and header files installed from tar archives.

5. **`jdk` Images**:
   - Include JDK versions (from 6 to 21).
   - Have two tags:
     - Primary tag: inherits from `main`.
     - Developer tag: inherits from `develop`.

##### Final Images

In the directory `linux/ecosystem`, images for final products (e.g., `apache2`, `nginx`, `jira`, etc.) are located. These images typically inherit from the relevant final base image needed for the product.

#### Changes in Approach

To improve image management and ensure relevance, the following approach is proposed:

1. **Base Image Support**:
   - All existing base images (`slim`, `main`, `develop`, `nodejs`, `jdk`) will remain unchanged for each `Debian` version.
   - Base images will be periodically rebuilt to account for updates and backports.

2. **Introduction of `upstream` and `deprecated` Concepts**:
   - **`Upstream`**: Current final images will inherit from base images for the latest stable Debian version. Currently, this is Debian 12. When a new stable Debian version is released, final images will be transitioned to the new version.
   - **`Deprecated`**: For deprecated versions of base images, only the base images themselves will be available. Final images will not be updated for deprecated versions.

3. **Version Management**:
   - Current images will be rebuilt based on the latest stable Debian version.
   - Current images include `current` (`stable`, or `12`) branches as the main one, as well as `LTS` but lightweight (`11`) - only base images will be built.
   - The previous `LTS` branch stops being supported when a new one is assigned.
   - Upon the release of a new `Debian` version (e.g., `13`), all final images will be updated and transitioned to the new `Debian` version if it becomes `stable`.

4. **Periodic Image Updates**:
   - `All versions` of base images, including `deprecated` ones, will be periodically rebuilt to include updates and backports.

5. **Addition of New Base Images**:

   - Starting with the current upstream `version` (`12`), additional base images, such as `PHP` and `Python` or other, will be gradually added to the existing ones. These new base images will `not be` backported to previous deprecated versions. However, when the upstream transitions to a new version (e.g., `13`), the new base images will also transition to it and will be retained in the previous version (e.g., `12`).

#### Conclusion

This approach will allow for better version management and maintain the relevance of images in the repository. Transitioning to the upstream and deprecated concept will help focus on supporting current product versions and provide a more stable and predictable environment for end-users.
