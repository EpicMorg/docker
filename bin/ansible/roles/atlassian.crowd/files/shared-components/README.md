# Overview

This repository provides common utilities & components for building and testing Docker
images for Atlassian's Server and Data Center products.

The following components are provided:

### Image builds

* Support tools

   Scripts for performing common diagnostic operations, i.e. taking thread dumps and heap
   dumps.

* Entrypoint helpers

   Common components for bootstrapping and starting apps.

* README publishing

   Utility for publishing README's to Docker Hub, without relying on Docker Hub's own
   automated builds.

### Image testing

* Fixtures

   Common testing fixtures that can be reused for testing Docker builds of Atlassian
   apps.

* Helpers

   Helper functions for parsing configuration files, checking running processes and
   retrieving http responses.


