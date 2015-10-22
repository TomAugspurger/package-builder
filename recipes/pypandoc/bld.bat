"%PYTHON%" setup.py download_pandoc
if errorlevel 0 (
   echo "Build wheels..."
   "%PYTHON%" setup.py bdist_wheel
   echo "Upload wheels..."
   (
    @echo [distutils] # this tells distutils what package indexes you can push to
    @echo index-servers =
    @echo     pypi
    @echo    pypitest
    @echo. 
    @echo [pypi] # authentication details for live PyPI
    @echo repository: https://pypi.python.org/pypi
    @echo. 
    @echo [pypitest] # authentication details for test PyPI
    @echo repository: https://testpypi.python.org/pypiuse this file to run your own startup commands 
    ) > "pypirc"
   rem Upload via Twine
   @twine upload -u %PYPI_USER% -p %PYPI_PASS% --config-file pypirc -r pypitest dist/pypandoc-*.whl
)
echo "Cleanup wheel build..."
"%PYTHON%" setup.py clean
del /q pypandoc\files\*.*
del /q pandoc-*-windows.msi
del /q pypirc

"%PYTHON%" setup.py install --single-version-externally-managed  --record record.txt
if errorlevel 1 exit 1
