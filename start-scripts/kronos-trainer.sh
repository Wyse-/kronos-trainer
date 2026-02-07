#!/bin/bash

GAME_TARGET="Server is now listening on"
UPDATE_TARGET="Update Server is now listening on"

# Start game server and wait for init
cd ./kronos-server-1.0/bin || exit 1
KRONOS_SERVER_OPTS=-Djdk.attach.allowAttachSelf=true ./kronos-server 2>&1 | while IFS= read -r line; do
    echo "[kronos-server] $line"

    if [[ "$line" == *"$GAME_TARGET"* ]]; then
        echo "Game server is ready."
        # Start update server and wait for init
        (
            cd ../../kronos-update-server-1.0/bin || exit 1
            ./kronos-update-server 2>&1 | while IFS= read -r uline; do
                echo "[update-server] $uline"

                if [[ "$uline" == *"$UPDATE_TARGET"* ]]; then
                    echo "Update server is ready."
                    # After everything has launched, start client
                    cd ../../OpenOSRS-1.5.37-SNAPSHOT/bin || exit 1
                    ./OpenOSRS
                    wait $!
                    break
                fi
            done
        )

        break
    fi
done
