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

# Example: Start PowerShell in a separate window with the current directory as
# the working directory.
Start-ProcessUsingCommandLine -CommandLine 'powershell.exe -NoProfile'

# Example: Open README.txt in the current directory with Notepad.
Start-ProcessUsingCommandLine -CommandLine 'notepad.exe .\README.txt'

# Example: Automatically build Sphinx documentation in a new window.
Start-ProcessUsingCommandLine -CommandLine `
'uv run sphinx-autobuild .\source\ .\_build\html --open-browser'

# Example: In Windows Terminal, specify the tab name to start the process of
# automatically generating Sphinx documentation.
Start-ProcessUsingCommandLine -CommandLine `
('wt.exe --window 0 new-tab --title "sphinx-autobuild" -- ' +
'uv run sphinx-autobuild .\source\ .\_build\html --open-browser')

# Example: Execute commands periodically in a new window.
Start-ProcessUsingCommandLine -CommandLine `
('powershell.exe -NoProfile -NoExit -Command ' +
'"while ($true) { Get-Date -Format \""HH:mm:ss\""; Start-Sleep 1; }"')

# Example: In Windows Terminal, specify a tab name and run commands
# periodically in a new tab. Don't forget to escape the semicolon.
Start-ProcessUsingCommandLine -CommandLine `
('wt.exe --window 0 new-tab --title "loop" powershell.exe -NoProfile -NoExit ' +
'-Command "while ($true) { Get-Date -Format ''HH:mm:ss''\; Start-Sleep 1\; }"')

# Example: Execute ping commands periodically in a new window.
Start-ProcessUsingCommandLine -CommandLine 'powershell.exe -NoProfile -NoExit -Command "$target = ''www.google.com''; while ($true) { $date = Get-Date -UFormat ''%H:%M:%S''; ping -n 1 $target | Out-Null; $isOk = if ($?) { ''ok'' } else { ''not ok'' }; $message = \""$date $target $isOk\""; Write-Host $message; Start-Sleep 10; }"'

# Example: By adding `-WhatIf` and `-Verbose`, you can see how it is being
# analyzed.
Start-ProcessUsingCommandLine -CommandLine 'powershell.exe -NoProfile -Command "while ($true) { Get-Date -Format ""HH:mm:ss""; Start-Sleep 1; }"' -WhatIf -Verbose
```

## For more convinient way to load function

This is a method for loading remote code without installing it.

```powershell
$func = & { $ProgressPreference = 'SilentlyContinue'; $u = "https://raw.githubusercontent.com/kumarstack55/PSStart-ProcessUsingCommandLine/refs/heads/main/Start-ProcessUsingCommandLine.ps1"; $r = Invoke-WebRequest -UseBasicParsing -Uri $u; $c = $r | Select-Object -ExpandProperty Content; $c -replace "^\uFEFF", ""; }; Invoke-Expression "$func"

Start-ProcessUsingCommandLine -CommandLine "notepad.exe $HOME\Desktop\note.txt"
```

> **NOTE**
>
> Please note that loading remote code is generally not a secure practice.

## How to escape command line

Here's an example of escaping a one-liner.

```powershell
# powershell

# This is a single line of code that runs a ping periodically.
# Note that this code includes both single and double quotes.

$code = @'
$target = 'www.google.com'; while ($true) { $date = Get-Date -UFormat '%H:%M:%S'; ping -n 1 $target | Out-Null; $isOk = if ($?) { 'ok' } else { 'not ok' }; $message = "$date $target $isOk"; Write-Host $message; Start-Sleep 10; }
'@

$codes = [System.collections.generic.List[string]]::new()
$codes.Add($code)

# In this example, we later enclose it in double quotes like `-Command "..."`.
# First, escape double quotes with a backslash.
$codes.Add(($codes[$codes.Count - 1] -replace '"', '\"'))

# Then, escape the double quotes inside them.
$codes.Add(($codes[$codes.Count - 1] -replace '"', '""'))

# When representing strings with single quotes in PowerShell, you must escape any single quotes within the string.
$codes.Add(($codes[$codes.Count - 1] -replace "'", "''"))

$codes.Add(
@'
Start-ProcessUsingCommandLine -CommandLine 'powershell.exe -NoProfile -NoExit -Command "{0}"'
'@ -f $codes[$codes.Count - 1]
)

$escapedCode = $codes[$codes.Count - 1]
Write-Host $escapedCode
```

```plaintext
PS > Write-Host $escapedCode
Start-ProcessUsingCommandLine -CommandLine 'powershell.exe -NoProfile -NoExit -Command "$target = ''www.google.com''; while ($true) { $date = Get-Date -UFormat ''%H:%M:%S''; ping -n 1 $target | Out-Null; $isOk = if ($?) { ''ok'' } else { ''not ok'' }; $message = \""$date $target $isOk\""; Write-Host $message; Start-Sleep 10; }"'
```

## LICENSE

MIT
