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

