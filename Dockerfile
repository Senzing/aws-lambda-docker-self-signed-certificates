ARG BASE_IMAGE=public.ecr.aws/lambda/python:3.8@sha256:a04abc05330a09c239c3e3d62408dd8331c5b3e3ee323a3d8a29cb0fad4d5356
FROM ${BASE_IMAGE}

ENV REFRESHED_AT=2023-06-15

LABEL Name="senzing/self-signed-certificate" \
      Maintainer="support@senzing.com" \
      Version="1.0.3"

HEALTHCHECK CMD ["/app/healthcheck.sh"]

# Run as "root" for system installation.

USER root

# Install packages via PIP.

COPY requirements.txt .
RUN pip3 install --upgrade pip \
 && pip3 install -r requirements.txt \
 && pip3 install awslambdaric \
 && rm requirements.txt

# Copy files from repository.

COPY ./rootfs /
COPY self_signed_certificate.py ./

# Make non-root container.

USER 1001

# Runtime execution.

ENV SENZING_DOCKER_LAUNCHED=true

ENTRYPOINT ["/var/task/self_signed_certificate.py"]
