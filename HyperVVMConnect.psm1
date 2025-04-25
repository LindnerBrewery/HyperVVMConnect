<#
.SYNOPSIS
Connects to a Hyper-V VM via vmconnect.exe, with optional auto-start.

.PARAMETER Server
Hyper-V host server. Default is localhost.

.PARAMETER VMName
Name of the virtual machine.

.PARAMETER StartVM
If set, starts the VM automatically if it's not running, without prompting.
#>
function Connect-HyperVVM {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [string]$Server = 'localhost',

        [Parameter(Position = 1, Mandatory = $true)]
        [string]$VMName,

        [switch]$StartVM
    )

    try {
        $vm = Get-VM -ComputerName $Server -Name $VMName -ErrorAction Stop
    }
    catch {
        throw "Virtual machine '$VMName' not found on server '$Server'."
    }

    if ($vm.State -ne 'Running') {
        if ($StartVM) {
            Start-VM -ComputerName $Server -Name $VMName | Out-Null
        }
        else {
            $ans = Read-Host "VM '$VMName' is not running. Start it? (y/n)"
            if ($ans -match '^[Yy]') {
                Start-VM -ComputerName $Server -Name $VMName | Out-Null
            }
            else {
                Write-Host "Aborting connection."
                return
            }
        }
    }

    # Launch vmconnect.exe
    & vmconnect.exe $Server $VMName
}

# Register argument completer for VMName parameter
Register-ArgumentCompleter -CommandName 'Connect-HyperVVM' -ParameterName 'VMName' -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    try{

        $server = if ($fakeBoundParameters.ContainsKey('Server')) { $fakeBoundParameters['Server'] } else { 'localhost' }
        Hyper-V\Get-VM -ComputerName $server -ErrorAction stop | Where-Object { $_.Name -like "$wordToComplete*" } |
        ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_.Name, $_.Name, 'ParameterValue', $_.Name)
        }
    }
    catch {
        Write-Output "$($_.Exception.Message)"
    }
}

Export-ModuleMember -Function Connect-HyperVVM
