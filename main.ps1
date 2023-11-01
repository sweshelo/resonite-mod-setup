$ResoniteLocation = (Get-ChildItem -Path(
'HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall',
'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall') | % { Get-ItemProperty $_.PsPath } | ?{ $_.DisplayName -eq 'Resonite' }).InstallLocation

if([string]::IsNullOrEmpty($ResoniteLocation)){
  "Not found Resonite Install location."
  exit
}

echo $ResoniteLocation

$ResoniteLibsPath = "${ResoniteLocation}/rml_libs"
$ResoniteModsPath = "${ResoniteLocation}/rml_mods"

if(!(Test-Path $ResoniteLibsPath)){
  mkdir $ResoniteLibsPath
}

if (!(Test-Path $ResoniteModsPath)){
  mkdir $ResoniteModsPath
}

iwr "https://github.com/resonite-modding-group/ResoniteModLoader/releases/latest/download/ResoniteModLoader.dll" -OutFile "${ResoniteLocation}/Libraries/ResoniteModLoader.dll"
iwr "https://github.com/resonite-modding-group/ResoniteModLoader/releases/latest/download/0Harmony.dll" -OutFile "${ResoniteLibsPath}/0Harmony.dll"
iwr "https://github.com/badhaloninja/ResoniteModSettings/releases/latest/download/ResoniteModSettings.dll" -OutFile "${ResoniteModsPath}/ResoniteModSettings.dll"

echo "`"$(${ResoniteLocation} | Split-Path | Split-Path | Split-Path)\steam.exe`" -applaunch 2519830 --LoadAssembly `"${ResoniteLocation}\Libraries\ResoniteModLoader.dll`"" |  Out-File -FilePath Resonite.bat -Encoding utf8
