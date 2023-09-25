# transmission

Follow the below instructions to allow the Transmission daemon to run.

Note that configuration files must be glossed over and potentially further
edited, as not all configuration operations necessary are documented here.

1. Start the container, and close it to generate the configuration
2. Edit `data/config/settings.json`:

    ```json
    "blocklist-enabled": true,                                                              
    "blocklist-url": "https://github.com/Naunter/BT_BlockLists/raw/master/bt_blocklists.gz",
    ```

3. Set the watch/download directory to whatever is suitable
