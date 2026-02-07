$GAME_TARGET   = "Server is now listening on"
$UPDATE_TARGET = "Update Server is now listening on"

# Start game server and wait for init
Set-Location "./kronos-server-1.0/bin"
$env:KRONOS_SERVER_OPTS = "-Djdk.attach.allowAttachSelf=true"
& ./kronos-server.bat 2>&1 | ForEach-Object {
    $line = $_
    Write-Host "[kronos-server] $line"
    if ($line -like "*$GAME_TARGET*") {
        Write-Host "Game server is ready."
        # Start update server and wait for init
        Set-Location "../../kronos-update-server-1.0/bin"
        & ./kronos-update-server.bat 2>&1 | ForEach-Object {
            $uline = $_
            Write-Host "[update-server] $uline"
            if ($uline -like "*$UPDATE_TARGET*") {
                Write-Host "Update server is ready."
                # After everything has launched, start client
                Set-Location "../../OpenOSRS-1.5.37-SNAPSHOT/bin"
                & ./OpenOSRS.bat
            }
        }
        break
    }
}
