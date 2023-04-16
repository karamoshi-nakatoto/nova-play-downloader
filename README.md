# Nova Play Downloader

This is an automated bash script which can save series episodes from https://play.nova.bg/ to your local disk.

The required dependencies are curl, jq and ffmpeg.

```shell
$ sudo apt install curl jq ffmpeg
```

The script takes two positional arguments - the first is the episode number, and the second is the Nova Play URL.

In order to use, run it like this:

```shell
$ ./download.sh 1 https://play.nova.bg/video/s-reka-na-surceto/season-1/s-reka-na-surceto-2022-09-13/607998
```
