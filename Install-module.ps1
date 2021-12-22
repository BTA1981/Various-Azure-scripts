$installedModules = Get-InstalledModule
if ($installedModules.Name -notmatch "Az") {
    Install-Module Az -Force -AllowClobber
}
