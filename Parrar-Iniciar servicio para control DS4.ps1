param([switch]$Elevated)

function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false)  {
    if ($elevated) {
        # tried to elevate, did not work, aborting
    } else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
    }
    exit
}


$servicio_nombre="NvContainerLocalSystem"

$servicio=get-service -Name $servicio_nombre

$servicio.Refresh()

if ($servicio.Status -eq "Running"){

    Stop-Service -Force $servicio_nombre

    Write-Host "El servicio $($servicio_nombre) fue parado."
}
else{

    Start-Service $servicio_nombre

    Write-Host "El servicio $($servicio_nombre) fue iniciado."

    Start-Sleep -Seconds 2

    $servicio.Refresh()

    if ($servicio.Status -eq "Running"){

        Write-Host "El servicio $($servicio_nombre) esta corriendo."

    }

}
Start-Sleep -Seconds 2