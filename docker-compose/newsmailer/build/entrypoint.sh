#!/bin/sh

. /etc/newsapi/newsapi.sh

main() {
    export NEWS2RSS_API_KEY="${KEY_NEWSAPI}"
    if [ -z "${NEWS2RSS_API_KEY}" ]; then
        echo "No NewsAPI key set" >&2
        exit 1
    fi

    set -x

    (
        news2rss -d
    ) &

    # NOTE: give the server some time to start
    sleep 10

    for account in /data/*; do
        set -e

        cd "${account}"
        export XDG_CONFIG_HOME="${PWD}" XDG_DATA_HOME="${PWD}"

        while true; do
            if [ -e newsmailer.sh ]; then
                . newsmailer.sh
            fi

            newsboat-sendmail -du -C newsboat-sendmail/newsboat-sendmail.cfg

            while ! sendmail-tryqueue -Q newsboat-sendmail flush; do
                sleep 5m
            done

            if [ -z "${NEWSMAILER_INTERVAL}" ]; then
                echo "No interval set, waiting for a day by default" >&2
                sleep $((24 * 3600))
            else
                sleep "${NEWSMAILER_INTERVAL}"
            fi
        done
    done
}

main "$@"
