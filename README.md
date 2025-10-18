# PSStart-ProcessUsingCommandLine

Sometimes you want to run a command line in a new window using PowerShell.
The `Start-ProcessUsingCommandLine` function in this repository is useful for such situations.

For details, refer to the function's help.

## Requirements

- Windows PowerShell 5.1+

## Installation

```powershell
# powershell

git clone https://github.com/kumarstack55/PSStart-ProcessUsingCommandLine.git
```

## Usage

```powershell
# powershell

Set-Location .\PSStart-ProcessUsingCommandLine\
. .\Start-ProcessUsingCommandLine.ps1

# Example: Automatically build Sphinx documentation in a new window.
Start-ProcessUsingCommandLine -CommandLine 'uv run sphinx-autobuild .\source\ .\_build\html --open-browser'

# Example: Execute commands periodically in a new window.
Start-ProcessUsingCommandLine -CommandLine 'powershell.exe -NoProfile -Command "& { while ($true) { Get-Date; Start-Sleep 1; } }"'
```

## For more convinient way to load function

This is a method for loading remote code without installing it.

```powershell
$func = & { $ProgressPreference = 'SilentlyContinue'; $u = "https://raw.githubusercontent.com/kumarstack55/PSStart-ProcessUsingCommandLine/refs/heads/main/Start-ProcessUsingCommandLine.ps1"; $r = Invoke-WebRequest -Uri $u; $c = $r | Select-Object -ExpandProperty Content; $c -replace "^\uFEFF", ""; }; Invoke-Expression "$func"

Start-ProcessUsingCommandLine -CommandLine 'notepad.exe'
```

> **NOTE**
>
> Please note that loading remote code is generally not a secure practice.

## LICENSE

MIT
