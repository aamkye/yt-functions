#!/usr/bin/env bash

export PS4='+ $0:$LINENO '
set -efvx

function error {
  exit "${1}"
}

function check {
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
}

function sequential_download {
  youtube-dl \
    --console-title \
    --download-archive downloaded.txt \
    -ciwx \
    --audio-format mp3 \
    -o '%(title)s.%(id)s.%(ext)s' \
    --audio-quality 0 \
    --retries 60 \
    --fragment-retries 60 \
    --skip-unavailable-fragments \
    --restrict-filenames \
    "${1}"
}

function parallel_download {
  check "${1}" "${2}"

  pushd "${1}" 1>/dev/null

  echo "${2}" > url.txt

  if [[ "${YT_NO_PARALLEL:-'0'}" -eq "1" ]]; then
    youtube-dl \
      --get-id "${2}" \
      --limit-rate 10k \
      --retries 60 \
      --fragment-retries 60 \
      --skip-unavailable-fragments \
      --playlist-random -i | \
        parallel -j $(nproc) -l $(nproc) --linebuffer -- \
          "youtube-dl \
            --console-title \
            --download-archive downloaded.txt \
            -ciwx \
            --audio-format mp3 \
            -o '%(title)s.%(id)s.%(ext)s' \
            --audio-quality 0 \
            --retries 60 \
            --fragment-retries 60 \
            --skip-unavailable-fragments \
            --restrict-filenames --" || true
  fi

  sequential_download "${2}" || true

  popd 1>/dev/null
}
