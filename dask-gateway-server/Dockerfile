FROM python:3.9-slim-bullseye as dependencies
LABEL MAINTAINER="Jim Crist-Harif"

RUN apt-get update \
    && apt-get install -y tini git \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir \
    aiohttp==3.8.1 \
    colorlog \
    cryptography \
    traitlets==5.1.1 \
    pyyaml \
    htcondor \
    kubernetes-asyncio==18.20.0



# Build dask-gateway-server from source in a builder stage
FROM dependencies AS builder

RUN mkdir -p /tmp/workdir
RUN mkdir -p /tmp/install-prefix
COPY . /tmp/workdir/
WORKDIR /tmp/workdir/
RUN python setup.py install \
    --no-build-proxy \
    --single-version-externally-managed \
    --record=record.txt \
    --prefix /tmp/install-prefix



# Final image - merge dependencies and built dask-gateway
FROM dependencies

COPY --from=builder /tmp/install-prefix/bin/dask-gateway-server /usr/local/bin/
COPY --from=builder /tmp/install-prefix/lib /usr/local/lib/

# Create non-root user and working directory
WORKDIR /srv/dask-gateway
RUN useradd -m -U -u 1000 dask && chown dask:dask /srv/dask-gateway

# Latest versions can be found at:
# - dask:           https://anaconda.org/conda-forge/dask
# - distributed:    https://anaconda.org/conda-forge/distributed
#ARG DASK_VERSION=2.30.0
#ARG DISTRIBUTED_VERSION=2.30.1

# Need to downgrade dask and distributed
#RUN /opt/conda/bin/conda install -c conda-forge -y \
#        aiohttp=3.8.1 \
#        dask==$DASK_VERSION \
#        distributed==$DISTRIBUTED_VERSION \
#        numpy==1.21.4 \
#        pandas==1.3.4 \
#    && /opt/conda/bin/conda clean -afy \
#    && find /opt/conda/ -follow -type f -name '*.a' -delete \
#    && find /opt/conda/ -follow -type f -name '*.js.map' -delete \
#    && find /opt/conda/lib/python*/site-packages/bokeh/server/static -follow -type f -name '*.js' ! -name '*.min.js' -delete

USER 1000:1000

ENTRYPOINT ["tini", "-g", "--"]
CMD ["dask-gateway-server", "--config", "/etc/dask-gateway/dask_gateway_config.py"]
