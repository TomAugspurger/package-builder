#!/bin/bash

$PYTHON setup.py download_pandoc 
if [ "$(uname -s)" != "Linux" ]; 
then
  echo "Build wheels..."
  $PYTHON setup.py bdist_wheel
  echo "Upload wheels..."
  cat << EOF > pypirc
[distutils] # this tells distutils what package indexes you can push to
index-servers =
    pypi
    pypitest

[pypi] # authentication details for live PyPI
repository: https://pypi.python.org/pypi

[pypitest] # authentication details for test PyPI
repository: https://testpypi.python.org/pypi
EOF
  # set +x because we don't want to echo the user and password to the log
  #  +e because we might want to redo the conda packages only, but twine would error if the 
  #     wheel was already uploaded
  set +x +e
  echo "uploading via twine"
  twine upload -u $PYPI_USER -p $PYPI_PASS --config-file pypirc -r pypi dist/pypandoc-*.whl
  set -x -e
fi

# rm pypandoc/files/*.*

$PYTHON setup.py install --single-version-externally-managed  --record record.txt
