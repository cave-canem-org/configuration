# ArchiveBox configuration instructions

1. Create the `data` directory.

2. Setup the container:

    docker compose exec -u archivebox archivebox archivebox init --setup

## Importing data programatically

If any tags in the bookmarks contain space characters, the shell script that follows will need to be tweaked (it’s used as a separator between URL its tags).

Below, `script.sh` generates a JSON array of object with a `url` and `tags` (comma-separated) attributes:

```bash
script.sh | jq -r '.[] | "\(.tags) \(.url)"' | while read -r i; do tags="${i%% *}"; url="${i#* }"; printf '%s [%s]\n' "${url}" "${tags}"; docker compose exec -T -u archivebox archivebox archivebox add --tag "${tags}" "${url}" </dev/null; done
```

The `-T` and `</dev/null` tweaks allow working around ArchiveBox’ import issues.
