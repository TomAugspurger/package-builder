#!/usr/bin/env bash

# NOTE: This script has been adapted from content generated by github.com/conda-forge/conda-smithy

REPO_ROOT=$(cd "$(dirname "$0")/.."; pwd;)
UPLOAD_OWNER="TomAugspurger"
IMAGE_NAME="pelson/obvious-ci:latest_x64"

config=$(cat <<CONDARC

channels:
 - ${UPLOAD_OWNER}
 - defaults

show_channel_urls: True

CONDARC
)

cat << EOF | docker run -i \
                        -v ${REPO_ROOT}/recipes:/conda-recipes \
                        -a stdin -a stdout -a stderr \
                        $IMAGE_NAME \
                        bash || exit $?

if [ "${BINSTAR_TOKEN}" ];then
    export BINSTAR_TOKEN=${BINSTAR_TOKEN}
fi
if [ "${PYPI_USER}" ];then
    export PYPI_USER=${PYPI_USER}
    export PYPI_PASS=${PYPI_PASS}
fi

export PYTHONUNBUFFERED=1
echo "$config" > ~/.condarc

# A lock sometimes occurs with incomplete builds. The lock file is stored in build_artefacts.
conda clean --lock

conda install --yes anaconda-client
conda config --set show_channel_urls yes
conda info
pip install twine
unset LANG

# These are some standard tools. But they aren't available to a recipe at this point (we need to figure out how a recipe should define OS level deps)
#yum install -y expat-devel git autoconf libtool texinfo check-devel

# These were specific to installing matplotlib. I really want to avoid doing this if possible, but in some cases it
# is inevitable (without re-implementing a full OS), so I also really want to ensure we can annotate our recipes to
# state the build dependencies at OS level, too.
yum install -y libXext libXrender libSM tk libX11-devel

#obvci_conda_build_dir /conda-recipes $UPLOAD_OWNER --build-condition "python >=3.4,<3.5|>=3.5,<3.6|>=2.7,<3"
CONDA_PY=34
obvci_conda_build_dir /conda-recipes $UPLOAD_OWNER --build-condition "python >=3.4,<3.5"
CONDA_PY=35
obvci_conda_build_dir /conda-recipes $UPLOAD_OWNER --build-condition "python >=3.5,<3.6"
CONDA_PY=27
obvci_conda_build_dir /conda-recipes $UPLOAD_OWNER --build-condition "python >=2.7,<3"

EOF

