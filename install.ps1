# Installs the kit into the user-level Copilot folders (~/.copilot/agents and ~/.copilot/skills), which GitHub
# Copilot CLI, the GitHub Copilot app and VS Code (Copilot harness) all read. Optionally also configures VS Code's
# Local harness to read them. Use this only if you do NOT install the kit as a plugin (that would load it twice).
[CmdletBinding()]
param(
    [switch]$ConfigureVSCode,
    [switch]$Force,
    [string]$Target = (Join-Path $HOME '.copilot')
)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path

function Copy-KitItem($source, $destination) {
    if ((Test-Path $destination) -and -not $Force) {
        Write-Warning "Skipped (exists, use -Force to overwrite): $destination"
        return
    }
    New-Item -ItemType Directory -Force (Split-Path -Parent $destination) | Out-Null
    Copy-Item $source $destination -Force
    Write-Host "Installed $destination"
}

Get-ChildItem (Join-Path $root 'agents') -Filter *.agent.md | ForEach-Object {
    Copy-KitItem $_.FullName (Join-Path $target "agents\$($_.Name)")
}
Get-ChildItem (Join-Path $root 'skills') -Directory | ForEach-Object {
    Copy-KitItem (Join-Path $_.FullName 'SKILL.md') (Join-Path $target "skills\$($_.Name)\SKILL.md")
}

if ($ConfigureVSCode) {
    $settings = Join-Path $env:APPDATA 'Code\User\settings.json'
    if (-not (Test-Path $settings)) { '{}' | Set-Content $settings -Encoding utf8 }
    Copy-Item $settings "$settings.bak-$(Get-Date -Format yyyyMMddHHmmss)"
    $json = Get-Content $settings -Raw | ConvertFrom-Json
    $values = @{
        'chat.agentFilesLocations'  = [pscustomobject]@{ '~/.copilot/agents' = $true }
        'chat.agentSkillsLocations' = [pscustomobject]@{ '~/.copilot/skills' = $true }
        'chat.useAgentSkills'       = $true
    }
    foreach ($key in $values.Keys) {
        $json | Add-Member -NotePropertyName $key -NotePropertyValue $values[$key] -Force
    }
    $json | ConvertTo-Json -Depth 20 | Set-Content $settings -Encoding utf8
    Write-Host "Updated VS Code settings (backup next to $settings)"
}
Write-Host "Done. Restart VS Code / start a new Copilot session to pick up the agents and skills."

