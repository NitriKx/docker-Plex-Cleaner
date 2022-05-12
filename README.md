# Plex-Cleaner Docker

[![Build docker image](https://github.com/NitriKx/docker-Plex-Cleaner/actions/workflows/build-image.yml/badge.svg)](https://github.com/NitriKx/docker-Plex-Cleaner/actions/workflows/build-image.yml)

Dokerized version of [ngovil21/Plex-Cleaner](https://github.com/ngovil21/Plex-Cleaner)

## First run 

```
docker pull nitrikx/plex-cleaner
docker run -ti -v /path/to/config/folder:/config nitrikx/plex-cleaner
```

## Testing 

```
docker run -ti -v /path/to/config/folder:/config nitrikx/plex-cleaner --test
```

## Execution frequency

```
# Run every 4 hours
docker run -ti -v /path/to/config/folder:/config -e "EXECUTION_CRON_EXPRESSION=0 */4 * * *" nitrikx/plex-cleaner

# Run once
docker run -ti -v /path/to/config/folder:/config -e "EXECUTION_CRON_EXPRESSION=ONCE" nitrikx/plex-cleaner
````

## `--reload_encoding`

If you need to pass the `--reload_encoding` parameter, you could do something like this
```
docker run -ti -v /path/to/config/folder:/config nitrikx/plex-cleaner --reload_encoding
```

## plex_delete = false

If you want to delete the file without passing by the Plex Web API, you need to mount your plex data directory:

```
docker run -ti -v /path/to/config/folder:/config -v /path/to/plex/folder:/plexdata nitrikx/plex-cleaner
```

and then adjust your configuration:

```
...
    "default_location": "/plexdata",
...
```

## Logs

You can also export the logs by mounting a volume on `/logs`:
```
docker run -ti -v /path/to/config/folder:/config -v /path/to/logs/folder:/logs nitrikx/plex-cleaner
```
