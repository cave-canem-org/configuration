# Deluge configuration instructions

Follow the below instructions to allow the Gitea server to run.

1. Set the proper UID/GID in .env (to match the current user’s IDs to make backing up easier) and create the `data` directory.
2. After the container was started and configuration created in `data`, edit `data/web.conf`:

    "base": "/deluge"
    The route set above depends on the location that the reverse proxy re-routes.

3. Change the password in `data/web.conf` by editing the `pwd_sha1` value:

    ```
    echo -n '<pwd_salt><password>' | sha1sum
    ```
    Make sure to edit the file when the container is stopped (it overwrites the file on shutdown).
