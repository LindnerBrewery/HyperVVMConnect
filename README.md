# HyperVVMConnect PowerShell Module

## Description
This module provides a single function, `Connect-HyperVVM`, which wraps the built-in `vmconnect.exe` tool to connect to a Hyper-V virtual machine. It adds convenience features:
- Automatic argument completion for local VMs
- Optional auto-start of the VM if it is not running
- Interactive prompt to start the VM when needed

## Prerequisites
- Windows with the Hyper-V role enabled
- PowerShell 5.1 or newer
- `vmconnect.exe` available on the system (installed with Hyper-V tools)
- Execution policy that allows importing modules (e.g., `RemoteSigned`)

## Installation
1. Copy `HyperVVMConnect.psm1` into a folder named `HyperVVMConnect` inside one of your PowerShell module paths (e.g., `Documents\WindowsPowerShell\Modules\HyperVVMConnect`).
2. Open PowerShell and run:
   ```powershell
   Import-Module HyperVVMConnect
   ```
3. Verify the function is available:
   ```powershell
   Get-Command Connect-HyperVVM
   ```

## Usage
```powershell
Connect-HyperVVM [-Server <string>] -VMName <string> [-StartVM]
```

### Parameters
- `-Server` (string)
  - The Hyper-V host to connect to. Default is `localhost`.
- `-VMName` (string, required)
  - The name of the virtual machine to connect to.
- `-StartVM` (switch)
  - If specified, automatically starts the VM if it is not already running, without prompting.

## Examples
```powershell
# Connect to a local VM named 'MyVM', prompt to start if needed
Connect-HyperVVM -VMName 'MyVM'

# Connect to a remote Hyper-V server and auto-start the VM if stopped
Connect-HyperVVM -Server 'HyperV01' -VMName 'TestVM' -StartVM
```

## Argument Completion
The `VMName` parameter supports tab completion for VMs on the target server. Simply type part of the name and press `Tab`.

## License
MIT License. Feel free to use and modify as needed.
