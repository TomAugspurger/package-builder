#!/bin/bash

# we check our return status..
set +e
platform = $(expr substr $(uname -s) 1 5)

$PYTHON setup.py download_pandoc 
if [ $? -eq 0  && ${platform} != "Linux" ]; 
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
  set +x
  echo "uploading via twine"
  twine upload -u $PYPI_USER -p $PYPI_PASS --config-file pypirc -r pypitest dist/pypandoc-*.whl
  set -x
fi

# rm pypandoc/files/*.*

$PYTHON setup.py install --single-version-externally-managed  --record record.txt
exit $?
