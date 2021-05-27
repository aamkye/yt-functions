#!/usr/bin/env bash

export PS4='+ $0:$LINENO '

function error {
  exit "${1}"
}

function check {
  # set -efvx

  if [[ -z "${1}" ]]; then
    error "ERROR: No path selected"
  fi
  if [ ! -d "${1}" ]; then
    mkdir -p $(pwd)/"${1}"
  fi

  if [[ -z "${2}" ]]; then
    error "ERROR: No URL provided"
  fi
  if [[ ! -x "$(command -v parallel)" ]]; then
    error "ERROR: No 'parallel' binary found"
  fi
  if [[ ! -x "$(command -v jq)" ]]; then
    error "ERROR: No 'jq' binary found"
  fi
}

function __sequential_download {
  # set -efvx

  youtube-dl \
    --console-title \
    --download-archive downloaded.txt \
    -ciwx \
    --audio-format mp3 \
    -o "${YT_FORMAT:-%(title)s.%(id)s.%(ext)s}" \
    --audio-quality 0 \
    --retries 60 \
    --fragment-retries 60 \
    --skip-unavailable-fragments \
    --restrict-filenames -- \
    "${1}"
}

function parallel_download {
  set -efvx

  check "${1}" "${2}"

  pushd "${1}" 1>/dev/null

  echo "${2}" > url.txt

  if [[ "${YT_PARALLEL:-0}" -eq "1" ]]; then
    youtube-dl \
      --match-filter '!is_live' \
      --flat-playlist \
      --dump-json \
      --retries 60 \
      --fragment-retries 60 \
      --skip-unavailable-fragments \
      -i "$2" | jq -r '.id' > tmp.txt

    cat tmp.txt | \
      parallel \
        -j "${YT_CORES:-$(nproc)}" \
        --linebuffer -- \
          "youtube-dl \
            --console-title \
            --download-archive downloaded.txt \
            -ciwx \
            --audio-format mp3 \
            -o '${YT_FORMAT:-%(title)s.%(id)s.%(ext)s}' \
            --audio-quality 0 \
            --retries 60 \
            --fragment-retries 60 \
            --skip-unavailable-fragments \
            --restrict-filenames --" || true

    rm -f tmp.txt
  fi

  # To verify previous command has downloaded everything.
  __sequential_download "${2}" || true

  popd 1>/dev/null
}
