# Matrix configuration instructions

Follow the below instructions to allow the Gitea server to run.

Note that configuration files must be glossed over and potentially further
edited, as not all configuration operations necessary are documented here.

1. Set the proper UID/GID in .env (to match the current user’s IDs to make backing up easier) and create `data/db`
2. Edit the configuration file at `data/gitea/gitea/conf/app.ini`:

    ```ini
    [openid]
    ENABLE_OPENID_SIGNIN = false
    ENABLE_OPENID_SIGNUP = false

    [service]
    DISABLE_REGISTRATION = true
    REQUIRE_SIGNIN_VIEW = true
    ENABLE_CAPTCHA = true
    REQUIRE_CAPTCHA_FOR_LOGIN = true
    REQUIRE_EXTERNAL_REGISTRATION_CAPTCHA = true
    CAPTCHA_TYPE = recaptcha
    RECAPTCHA_SECRET = …
    RECAPTCHA_SITEKEY = …
    ```

3. Create an administrator user:

    docker compose exec -u $(id -u) gitea sh
    gitea admin user create --username administrator --password o8a7634g87a3w9847 --must-change-password --admin --email e@ma.il

4. Log into the account, and change the password accordingly
