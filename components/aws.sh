function s3_presign() {
  read -p 'S3 Url (eg s3://brits-dam-live/0dd134c3-3583-4c2c-9d56-39179559ebb2.mov):' s3_url
  read -p 'Expires In Seconds (default 300):' expires_in
  echo "$s3_url"
  if [[ -z "$s3_url" ]]
  then
    echo 'Failed - Must provide S3 Url!'
    echo ''
    return 1
  fi
  aws s3 presign "$s3_url" --expires-in "${expires_in:-300}" | pbcopy
  pbpaste
}

sqs_peak_to_file() {
  # peak the messages from the SQS queue to a file
  # make sure they can all be written before the visibility timeout

  if [ "${#}" -lt 2 ]; then
    echo "usage: drain-sqs-to-file <queue-url> <output-file>" >&2
    return 2
  fi

  local queue_url="${1}"
  local out_file="${2}"
  local aws_cmd="${AWS_CMD:-aws}"

  touch "${out_file}"

  while true; do
    local resp
    resp="$(${aws_cmd} sqs receive-message \
      --queue-url "${queue_url}" \
      --max-number-of-messages 10 \
      --wait-time-seconds 1 \
      --output json)"

    local count
    count="$(printf '%s' "${resp}" | jq -r '.Messages | length // 0' 2>/dev/null || echo 0)"
    case "${count}" in
      ''|*[!0-9]*) count=0 ;;
    esac
    if [ "${count}" -eq 0 ]; then
      break
    fi

    # dump messages (one json object per line)
    printf '%s' "${resp}" | jq -c '.Messages[]' >> "${out_file}"
  done

  echo "Done."
}