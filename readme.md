```
db    db d888888b        d88888b db    db d8b   db  .o88b. d888888b d888888b  .d88b.  d8b   db .d8888.
`8b  d8' `~~88~~'        88'     88    88 888o  88 d8P  Y8 `~~88~~'   `88'   .8P  Y8. 888o  88 88'  YP
 `8bd8'     88           88ooo   88    88 88V8o 88 8P         88       88    88    88 88V8o 88 `8bo.
   88       88    C8888D 88~~~   88    88 88 V8o88 8b         88       88    88    88 88 V8o88   `Y8b.
   88       88           88      88b  d88 88  V888 Y8b  d8    88      .88.   `8b  d8' 88  V888 db   8D
   YP       YP           YP      ~Y8888P' VP   V8P  `Y88P'    YP    Y888888P  `Y88P'  VP   V8P `8888Y'
```

---

## Desc

Simple wrapper that allows multiple downloads and conversion to mp3 at the same time using linux tooling and youtube-dl.

It was mainly created to boost initial download of large playlists, and have been tested on playlists with 1k+ videos.

---

## Requirements

* youtube-dl
* parallel
* jq

---

## Options

* YT_PARALLEL (default: 0)
* YT_CORES (default: $(nproc))
* YT_FORMAT (default: '%(title)s.%(id)s.%(ext)s')

%(id) is used for

---

## Usage

```
parallel_download <folderName> <urlWithVideos>
YT_PARALLEL=1 parallel_download <folderName> <urlWithVideos>
```

Please mind that `__sequential_download` is invoked in `parallel_download` for confirmation of downloaded items and update

---

## Sample `update.sh` script:

```
#!/usr/bin/env bash

source <path>/yt-functions/update.sh

parallel_download x1 https://www.youtube.com/playlist\?list\=asdf
parallel_download y2 https://www.youtube.com/c/asdf
parallel_download z3 https://www.youtube.com/user/asdf
parallel_download q4 https://www.youtube.com/channel/asdf
parallel_download w5 https://www.youtube.com/c/asdf/videos
```

---

## Used materials

* https://archive.zhimingwang.org/blog/2014-11-05-list-youtube-playlist-with-youtube-dl.html

---

Made with <3 in Poland.
