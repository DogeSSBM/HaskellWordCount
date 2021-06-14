function Get-ProcessOutput {
	Param (
		[Parameter(Mandatory=$true)]$FileName,
		$Args
	)

	$process = New-Object System.Diagnostics.Process
	$process.StartInfo.UseShellExecute = $false
	$process.StartInfo.RedirectStandardOutput = $true
	$process.StartInfo.RedirectStandardError = $true
	$process.StartInfo.FileName = $FileName
	if($Args) { $process.StartInfo.Arguments = $Args }
	$out = $process.Start()

	$StandardError = $process.StandardError.ReadToEnd()
	$StandardOutput = $process.StandardOutput.ReadToEnd()
	$ExitCode = $process.ExitCode

	$output = New-Object PSObject
	$output | Add-Member -type NoteProperty -name StandardOutput -Value $StandardOutput
	$output | Add-Member -type NoteProperty -name StandardError -Value $StandardError
	$output | Add-Member -type NoteProperty -name ExitCode -Value $ExitCode
	return $output
}

function Run-Ps {
	Param (
		[Parameter(Mandatory=$true)]$Args
	)
	return (Get-ProcessOutput -FileName "powershell.exe" -Args $Args)
}

# $result = Run-Ps -Args "Write-Host"
# $result.StandardOutput
# $result.StandardError
# $result.ExitCode

Clear-Host

$compilationOutput = Run-Ps -Args "ghc .\Main.hs"
# ghc .\Main.hs
if ($compilationOutput.ExitCode -eq 0) {
	$haskellOutput = Run-Ps -Args ".\Main.exe"
} else {
	Write-Host "`nError during compilation... Exit code: $($compilationOutput.ExitCode)" -ForegroundColor Red
	# $compilationOutput.StandardOutput
	# $compilationOutput.StandardError
	ghc .\Main.hs
}

$haskellOutput.StandardOutput
$haskellOutput.StandardError
