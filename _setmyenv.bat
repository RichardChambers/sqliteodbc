
echo setting up the Visual Studio 2019 compile environment

for /f "usebackq tokens=*" %%i in (`"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do (
  set InstallDir=%%i
)

%comspec% /k "%InstallDir%\Common7\Tools\VsDevCmd.bat"

