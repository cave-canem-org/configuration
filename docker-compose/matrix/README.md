# Matrix configuration instructions

Follow the above instructions to allow the Matrix node and its components to
run.

Note that configuration files must be glossed over and potentially further
edited, as not all configuration operations necessary are documented here.

1. Set the proper UID/GID in .env: match the current user’s IDs to make backing up easier
2. Generate the homeserver configuration

	docker run --rm -ti -v `pwd`/data/synapse:/data -e SYNAPSE_SERVER_NAME=cave-canem.org -e SYNAPSE_REPORT_STATS=no -e UID=${UID_SYNAPSE} -e GID=${GID_SYNAPSE} matrixdotorg/synapse:v${VERSION_SYNAPSE} generate

3. Edit the homeserver configuration
4. Download `matrix-synapse-shared-secret-auth` and place into the appropriate directory:

	https://github.com/devture/matrix-synapse-shared-secret-auth

5. Download `matrix-synapse-rest-password-provider` and place into the appropriate directory:

	https://github.com/ma1uta/matrix-synapse-rest-password-provider

6. Create the Corporal user, with admin privileges:

	docker compose exec synapse register_new_matrix_user -a -u matrix-corporal -p <password> -c /data/homeserver.yaml http://localhost:8008

    This user is the one to authenticate as to administer all bridges.

7. Generate the Heisenbridge registration manifest:

	docker volume create data-heisenbridge
	docker run --rm -ti -v data-heisenbridge:/data hif1/heisenbridge:${VERSION_HEISENBRIDGE} --generate -c /data/heisenbridge.yml -l heisenbridge

8. Edit the homeserver configuration to add Heisenbridge to it
9. Use the `MEDIAURL` command in the control room (PM `@heisenbridge:cave-canem.org`) to set the correct media URL:

	MEDIAURL https://matrix.cave-canem.org/

10. Allow users to use the bridge:

	ADDMASK *:cave-canem.org

11. Generate the Mautrix Telegram configuration:

	docker volume create data-telegram
	docker run --rm -ti -v data-telegram:/data dock.mau.dev/mautrix/telegram:v${VERSION_TELEGRAM}

12. Modify the configuration file:

	docker volume inspect data-telegram | jq -r '.[0].Mountpoint'
	sudo -e /var/lib/docker/volumes/data-telegram/_data/config.yaml

    ```
    homeserver:
        address: http://synapse:8008/
        domain: cave-canem.org
    appservice:
        address: http://telegram:29317
        database: sqlite:/data/mautrix_telegram.sqlite
        provisioning:
            shared_secret: …
            double_puppet_server_map:
                cave-canem.org: http://synapse:8008/
            login_shared_secret_map:
                cave-canem.org: …
    permissions:
        "cave-canem.org": "full"
        "@matrix-corporal:cave-canem.org": "admin"
    telegram:
        api_id: …
        api_hash: …
    ```

13. Generate the Mautrix Telegram manifest:

	docker run --rm -ti -v data-telegram:/data dock.mau.dev/mautrix/telegram:v${VERSION_TELEGRAM}

14. Edit the homeserver configuration to add Mautrix Telegram to it
15. Generate the Mautrix WhatsApp configuration:

	docker volume create data-whatsapp
	docker run --rm -ti -v data-whatsapp:/data dock.mau.dev/mautrix/whatsapp:v${VERSION_WHATSAPP}

16. Modify the configuration file:

	docker volume inspect data-whatsapp | jq -r '.[0].Mountpoint'
	sudo -e /var/lib/docker/volumes/data-whatsapp/_data/config.yaml

    ```
    homeserver:
        address: http://synapse:8008/
        domain: cave-canem.org
    appservice:
        address: http://whatsapp:29318
        database:
            type: sqlite3-fk-wal
            uri: file:///data/mautrix_whatsapp.sqlite?_txlock=immediate
    bridge:
        displayname_template: "{{or .BusinessName .PushName .JID}} (WhatsApp)"
        double_puppet_server_map:
            cave-canem.org: http://synapse:8008/
        login_shared_secret_map:
            cave-canem.org: …
    permissions:
        "cave-canem.org": "user"
        "@matrix-corporal:cave-canem.org": "admin"
    ```

17. Generate the Mautrix WhatsApp manifest:

	docker run --rm -ti -v data-whatsapp:/data dock.mau.dev/mautrix/whatsapp:v${VERSION_WHATSAPP}

18. Fix the permissions of the WhatsApp manifest:

	docker volume inspect data-whatsapp | jq -r '.[0].Mountpoint'
	sudo chmod 644 /var/lib/docker/volumes/data-whatsapp/_data/registration.yaml

19. Edit the homeserver configuration to add Mautrix WhatsApp to it
