param(
    [string]$MachineList = "MachineList.txt",
    [string]$ScriptPath = "\\s-amusdat-ile03\Cyber-Review\GlobalR\GlobalFinder_2.3.py"
)

# Initialize counters
$totalMachines = 0
$successCount = 0
$failedCount = 0

# Read list of machines from file
$machines = Get-Content -Path $MachineList

# Iterate through each machine
foreach ($machine in $machines) {
    $totalMachines++
    Write-Host "Deploying script to $machine..."

    try {
        # Copy script to target machine
        $destinationPath = "\\$machine\c$\temp\TargetScript.ps1"
        Copy-Item -Path $ScriptPath -Destination $destinationPath

        # Execute script on target machine
        Invoke-Command -ComputerName $machine -ScriptBlock {
            Set-ExecutionPolicy Bypass -Scope Process -Force
            & "C:\temp\TargetScript.ps1"
        } -ErrorAction Stop

        $successCount++
        Write-Host "Deployment successful on $machine."
    } catch {
        $failedCount++
        Write-Host "Deployment failed on $machine. Error: $($_.Exception.Message)"
    }
}

# Display summary
Write-Host "Deployment Summary:"
Write-Host "  Total machines: $totalMachines"
Write-Host "  Successful deployments: $successCount"
Write-Host "  Failed deployments: $failedCount"
