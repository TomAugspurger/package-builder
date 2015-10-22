"%PYTHON%" setup.py download_pandoc
echo "Build wheels..."
"%PYTHON%" setup.py bdist_wheel

(
@echo [distutils] # this tells distutils what package indexes you can push to
@echo index-servers =
@echo    pypi
@echo    pypitest
@echo. 
@echo [pypi] # authentication details for live PyPI
@echo repository: https://pypi.python.org/pypi
@echo. 
@echo [pypitest] # authentication details for test PyPI
@echo repository: https://testpypi.python.org/pypiuse this file to run your own startup commands 
) > "pypirc"

echo "Upload wheels..."
@twine upload -u %PYPI_USER% -p %PYPI_PASS% --config-file pypirc -r pypitest dist/pypandoc-*.whl

:: del /q pypandoc\files\*.*

"%PYTHON%" setup.py install --single-version-externally-managed  --record record.txt
if errorlevel 1 exit 1
