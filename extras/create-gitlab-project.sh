#!/usr/bin/env bash

# Uncomment the following and define proper values (or specify as environment variables)

# GITLAB_HOST=https://gitlab.example.com
# GITLAB_USER=foo
# GITLAB_API_TOKEN=abc123
# GITLAB_PROJECT=model-driven-devops
# VIRL_HOST=cml.example.com
# VIRL_USERNAME=foo
# VIRL_PASSWORD=bar
# VIRL_LAB=model-driven-devops
# AWS_ACCESS_KEY_ID=
# AWS_SECRET_ACCESS_KEY=
# AWS_REGION=
# AWS_BUCKET=

# Add new project
curl --request POST -Lk --header "PRIVATE-TOKEN: $GITLAB_API_TOKEN" "$GITLAB_HOST/api/v4/projects" --form "name=$GITLAB_PROJECT"

# Add new vars
curl --request POST -Lk --header "PRIVATE-TOKEN: $GITLAB_API_TOKEN" "$GITLAB_HOST/api/v4/projects/$GITLAB_USER%2f$GITLAB_PROJECT/variables" --form "key=VIRL_HOST" --form "value=$VIRL_HOST"
curl --request POST -Lk --header "PRIVATE-TOKEN: $GITLAB_API_TOKEN" "$GITLAB_HOST/api/v4/projects/$GITLAB_USER%2f$GITLAB_PROJECT/variables" --form "key=VIRL_USERNAME" --form "value=$VIRL_USERNAME"
curl --request POST -Lk --header "PRIVATE-TOKEN: $GITLAB_API_TOKEN" "$GITLAB_HOST/api/v4/projects/$GITLAB_USER%2f$GITLAB_PROJECT/variables" --form "key=VIRL_PASSWORD" --form "value=$VIRL_PASSWORD"
curl --request POST -Lk --header "PRIVATE-TOKEN: $GITLAB_API_TOKEN" "$GITLAB_HOST/api/v4/projects/$GITLAB_USER%2f$GITLAB_PROJECT/variables" --form "key=VIRL_LAB" --form "value=$VIRL_LAB"
curl --request POST -Lk --header "PRIVATE-TOKEN: $GITLAB_API_TOKEN" "$GITLAB_HOST/api/v4/projects/$GITLAB_USER%2f$GITLAB_PROJECT/variables" --form "key=AWS_ACCESS_KEY_ID" --form "value=$AWS_ACCESS_KEY_ID"
curl --request POST -Lk --header "PRIVATE-TOKEN: $GITLAB_API_TOKEN" "$GITLAB_HOST/api/v4/projects/$GITLAB_USER%2f$GITLAB_PROJECT/variables" --form "key=AWS_SECRET_ACCESS_KEY" --form "value=$AWS_SECRET_ACCESS_KEY"
curl --request POST -Lk --header "PRIVATE-TOKEN: $GITLAB_API_TOKEN" "$GITLAB_HOST/api/v4/projects/$GITLAB_USER%2f$GITLAB_PROJECT/variables" --form "key=AWS_REGION" --form "value=$AWS_REGION"
curl --request POST -Lk --header "PRIVATE-TOKEN: $GITLAB_API_TOKEN" "$GITLAB_HOST/api/v4/projects/$GITLAB_USER%2f$GITLAB_PROJECT/variables" --form "key=AWS_BUCKET" --form "value=$AWS_BUCKET"
