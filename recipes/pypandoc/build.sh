#!/bin/bash
$PYTHON setup.py download_pandoc
if [ $? -eq 0 ]
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
  twine upload -u %PYPI_USER% -p %PYPI_PASS% --config-file pypirc -r pypitest dist/pypandoc-*.whl
fi
echo "Cleanup wheel build..."
$PYTHON setup.py clean
rm pypandoc\files\*.*
rm pandoc-*-osx.pkg
rm pandoc-*-amd64.deb
rm pypirc

$PYTHON setup.py install --single-version-externally-managed  --record record.txt

