set -xe

npm install -g configurable-http-proxy

pip install -U \
    aiohttp \
    colorlog \
    cryptography \
    dask \
    distributed \
    ipywidgets \
    jupyterhub \
    notebook \
    pytest \
    pytest-asyncio \
    sqlalchemy \
    tornado \
    traitlets \
    trustme

pushd dask-gateway
python setup.py develop
popd

pushd dask-gateway-server
python setup.py develop
popd

pip list

set +xe
