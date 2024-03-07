# Shiori configuration instructions

1. Create the `data` directory, and make sure it is write-able by a user with ID and GID equal to 1000:

    sudo chown "$(id -u)":1000 data
    sudo chmod 770 data

2. Log into the administrator account to change password (this new account will be an owner and the default account removed):

    shiori:gopher
