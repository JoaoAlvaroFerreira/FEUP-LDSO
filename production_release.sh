curl -X DELETE -H "PRIVATE-TOKEN: RL_bF6BJ7qj1_F6a4Jdz" "https://gitlab.com/api/v4/projects/14454869/releases/v0.5.0"
RESPONSE=$(curl -X POST -H "Private-Token: RL_bF6BJ7qj1_F6a4Jdz" -F "file=@.client/build/app/outputs/apk/release/app-arm64-v8a-release.apk" "https://gitlab.com/api/v4/projects/14454869/uploads")
UPLOAD_URL=`echo $RESPONSE| grep -o '"url": *"[^"]*"' | grep -o '"[^"]*"$'`
UPLOAD_URL="https://gitlab.com/feup-tbs/ldso1920/t1g3$UPLOAD_URL"
UPLOAD_URL=${UPLOAD_URL//'"'}
generate_post_data()
{
  cat <<EOF
{
  "name": "v0.5.0",
  "tag_name": "v0.5.0",
  "description": "v0.5.0 Release",
  "milestones": ["Sprint 5"],
  "assets": {
    "links": [
      {
      "name": "APK",
      "url": "$UPLOAD_URL"
    }]
  }
}
EOF
}
curl -H 'Content-Type: application/json' -H "PRIVATE-TOKEN: RL_bF6BJ7qj1_F6a4Jdz" -d "$(generate_post_data)" -X POST https://gitlab.com/api/v4/projects/14454869/releases
