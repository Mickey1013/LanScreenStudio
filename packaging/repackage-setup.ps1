$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true
$tag = "v$env:VERSION"
$base = "LanScreenStudio-$env:VERSION-Windows-x64"
$repo = $env:GITHUB_REPOSITORY
$installerName = "$base-Setup.exe"
$release = gh release view $tag --repo $repo --json assets | ConvertFrom-Json
if ($release.assets | Where-Object { $_.name -ceq $installerName -and $_.state -eq 'uploaded' -and $_.size -gt 1000000 }) {
  Write-Output 'The installer is already available.'
  return
}
$work = Join-Path $env:RUNNER_TEMP 'lanscreen-setup'
$portable = "$base-Portable.zip"
gh release download $tag --repo $repo --pattern $portable --dir $work
$bundle = Join-Path $work 'app-bundle'
Expand-Archive -LiteralPath (Join-Path $work $portable) -DestinationPath $bundle
$compilerHome = Join-Path $work 'inno-setup'
$gh = (Get-Command gh -ErrorAction Stop).Source
$compilerName = 'innosetup-6.5.4.exe'
& $gh release download is-6_5_4 --repo jrsoftware/issrc --pattern $compilerName --dir $work
$compilerInstaller = Join-Path $work $compilerName
$signature = Get-AuthenticodeSignature -LiteralPath $compilerInstaller
if ($signature.Status -ne 'Valid' -or $signature.SignerCertificate.Subject -notmatch 'Pyrsys|Jordan Russell') {
  throw 'Unexpected Inno Setup installer signature'
}
$compilerOptions = @('/PORTABLE=1','/CURRENTUSER','/VERYSILENT','/SUPPRESSMSGBOXES','/NORESTART',"/DIR=`"$compilerHome`"")
$result = Start-Process -FilePath $compilerInstaller -ArgumentList $compilerOptions -Wait -PassThru
if ($result.ExitCode -ne 0) { throw "Compiler installer exited with $($result.ExitCode)" }
$compiler = Join-Path $compilerHome 'ISCC.exe'
$output = Join-Path $work 'output'
& $compiler "/DBundleDir=$bundle" "/DProductVersion=$env:VERSION" "/DSetupOutput=$output" (Join-Path $PSScriptRoot 'windows.iss')
$installer = Join-Path $output $installerName
$destination = Join-Path $work 'test-install'
$options = @('/VERYSILENT','/SUPPRESSMSGBOXES','/NORESTART',"/DIR=`"$destination`"")
$result = Start-Process -FilePath $installer -ArgumentList $options -Wait -PassThru
if ($result.ExitCode -ne 0) { throw "Installer exit code $($result.ExitCode)" }
$installedExe = Get-Item -LiteralPath (Join-Path $destination 'LanScreenStudio.exe')
$installedPackage = Get-Content -LiteralPath (Join-Path $destination 'resources/app/package.json') -Raw | ConvertFrom-Json
if ($installedExe.Length -ne 249978368 -or $installedPackage.version -ne $env:VERSION) { throw 'Unexpected installed content' }
$uninstaller = Get-ChildItem -LiteralPath $destination -Filter 'unins*.exe' | Select-Object -First 1
$result = Start-Process -FilePath $uninstaller.FullName -ArgumentList '/VERYSILENT','/SUPPRESSMSGBOXES','/NORESTART' -Wait -PassThru
if ($result.ExitCode -ne 0 -or (Test-Path -LiteralPath $installedExe.FullName)) { throw 'Uninstall failed' }
$asset = Get-Item -LiteralPath $installer
gh release upload $tag $installer --repo $repo
$release = gh release view $tag --repo $repo --json assets | ConvertFrom-Json
if (!($release.assets | Where-Object { $_.name -ceq $asset.Name -and $_.size -eq $asset.Length -and $_.state -eq 'uploaded' })) { throw 'Published installer verification failed' }
