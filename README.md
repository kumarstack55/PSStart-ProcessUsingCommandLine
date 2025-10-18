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

# Example: Execute commands periodically in a new window.
Start-ProcessUsingCommandLine -CommandLine 'powershell.exe -NoProfile -Command "& { while ($true) { Get-Date; Start-Sleep 1; } }"'

# Example:
```

## LICENSE

MIT
