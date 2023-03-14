#!/usr/bin/env bash

# Uncomment the following and define proper values (or specify as environment variables)

GITLAB_HOST=http://devtools-gitlab.lab.devnetsandbox.local
GITLAB_USER=root
GITLAB_API_TOKEN=zbBCZoKtHK7PwsoouEYb
GITLAB_PROJECT=mdd

# Delete project
curl --request DELETE -sSLk --header "PRIVATE-TOKEN: $GITLAB_API_TOKEN" "$GITLAB_HOST/api/v4/projects/$GITLAB_USER%2f$GITLAB_PROJECT/"