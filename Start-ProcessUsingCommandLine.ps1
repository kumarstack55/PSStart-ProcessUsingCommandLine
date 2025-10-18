function Start-ProcessUsingCommandLine {
<#
.SYNOPSIS
    Start a process using command line parsing.

.DESCRIPTION
    This function takes a command line string, tokenizes it while ignoring comments,
    and starts the specified process with the parsed arguments.

    Unlike `&` operators, it executes asynchronously. Therefore, it runs in a separate window.

    Unlike Start-Process, the command line is parsed.

.PARAMETER CommandLine
    The command line string to be parsed and executed.

.EXAMPLE
    Start-ProcessUsingCommandLine -CommandLine 'cmd.exe'

.EXAMPLE
    Start-ProcessUsingCommandLine -CommandLine 'powershell.exe -NoProfile'

.EXAMPLE
    Start-ProcessUsingCommandLine -CommandLine '"C:\Program Files\teraterm5\ttermpro.exe" ssh://user@host:22 ; comment'

.EXAMPLE
    Start-ProcessUsingCommandLine -CommandLine 'powershell.exe -NoProfile -Command "& { while ($true) { Get-Date; Start-Sleep 1; } }"'

.NOTES
    DO NOT PROVIDE COMMAND LINES THAT TAKE INPUT FROM UNTRUSTED SOURCES.

.NOTES
    Token parsing may yield unexpected results. For example, IP addresses may be interpreted as PowerShell expressions. To verify whether this is as expected, use the `-WhatIf` option such like `Start-ProcessUsingCommandLine -CommandLine "`"C:\path\to\dig.exe`" -x 1.1.1.1" -WhatIf`.

    If unexpected behavior occurs, explicitly enclose the token in double quotes. For instance, instead of `"C:\path\to\dig.exe`" -x 1.1.1.1`, you may need to use `"C:\path\to\dig.exe`" -x "1.1.1.1"`.

.LINK
    https://github.com/kumarstack55/PSStart-ProcessUsingCommandLine.git

#>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [string]$CommandLine
    )

    # Tokenize the command line, ignoring comments.
    #
    # PSParser is primarily a class for syntax colorizations,
    # but here it is used to tokenize strings containing whitespace.
    $tokensMayContainComments = [System.Management.Automation.PSParser]::Tokenize($CommandLine, [ref]$null)
    if ($tokensMayContainComments.Count -eq 0) {
        throw "Failed to tokenize command line"
    }
    $tokens = $tokensMayContainComments | Where-Object { $_.Type -ne 'Comment' }
    if ($tokens.Count -eq 0) {
        throw "No tokens found"
    }

    # The first token is the file path, and the rest are arguments.
    $filePath = $tokens[0].Content
    $argumentList = [string[]]::new($tokens.Count - 1)
    for ($index = 0; $index -lt $tokens.Count - 1; $index++) {
        $argumentList[$index] = $tokens[$index + 1].Content
    }

    # Start the process.
    $operation = "FilePath: <$filePath>, ArgumentList: <$(($argumentList | ForEach-Object { "<$_>" }) -join ', ')>"
    if ($PSCmdlet.ShouldProcess("Start-Process", $operation)) {
        if ($argumentList.Count -eq 0) {
            Start-Process -FilePath $filePath
        } else {
            Start-Process -FilePath $filePath -ArgumentList $argumentList
        }
    }
}
