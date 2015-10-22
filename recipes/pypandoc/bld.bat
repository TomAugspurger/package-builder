"%PYTHON%" setup.py download_pandoc
if errorlevel 0 (
   echo "Build wheels..."
   "%PYTHON%" setup.py bdist_wheel
   echo "Upload wheels..."
   twine upload -u %PYPI_USER% -p %PYPI_PASS% --config-file %~dp0\pypirc -r pypitest dist/pypandoc-*.whl
)
echo "Cleanupwheel build..."
"%PYTHON%" setup.py clean
del /q pypandoc\files\*.*
del /q pandoc-*-windows.msi

"%PYTHON%" setup.py install --single-version-externally-managed  --record record.txt
if errorlevel 1 exit 1
