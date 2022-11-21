# Nova Play Downloader

This is an automated bash script which can save series episodes from https://play.nova.bg/ to your local disk.

The required dependencies are curl, jq and ffmpeg.

```shell
$ sudo apt install curl jq ffmpeg
```

The script takes two positional arguments - the first is the Nova Play API_ID, and the second is the episode number.

In order to use, run it like this:

```shell
$ ./download.sh 607998 1
```
