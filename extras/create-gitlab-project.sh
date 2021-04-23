#!/usr/bin/env bash

# Uncomment the following and define proper values (or specify as environment variables)

# GITLAB_HOST=https://gitlab.example.com
# GITLAB_USER=foo
# GITLAB_API_TOKEN=abc123
# GITLAB_PROJECT=model-driven-devops
# CML_HOST=cml.example.com
# CML_USERNAME=foo
# CML_PASSWORD=bar
# CML_LAB=model-driven-devops

# Add new project
curl --request POST -sSLk --header "PRIVATE-TOKEN: $GITLAB_API_TOKEN" "$GITLAB_HOST/api/v4/projects" --form "name=$GITLAB_PROJECT"

# Add new vars
curl --request POST -sSLk --header "PRIVATE-TOKEN: $GITLAB_API_TOKEN" "$GITLAB_HOST/api/v4/projects/$GITLAB_USER%2f$GITLAB_PROJECT/variables" --form "key=CML_HOST" --form "value=$CML_HOST"
curl --request POST -sSLk --header "PRIVATE-TOKEN: $GITLAB_API_TOKEN" "$GITLAB_HOST/api/v4/projects/$GITLAB_USER%2f$GITLAB_PROJECT/variables" --form "key=CML_USERNAME" --form "value=$CML_USERNAME"
curl --request POST -sSLk --header "PRIVATE-TOKEN: $GITLAB_API_TOKEN" "$GITLAB_HOST/api/v4/projects/$GITLAB_USER%2f$GITLAB_PROJECT/variables" --form "key=CML_PASSWORD" --form "value=$CML_PASSWORD"
curl --request POST -sSLk --header "PRIVATE-TOKEN: $GITLAB_API_TOKEN" "$GITLAB_HOST/api/v4/projects/$GITLAB_USER%2f$GITLAB_PROJECT/variables" --form "key=CML_LAB" --form "value=$CML_LAB"
curl --request POST -sSLk --header "PRIVATE-TOKEN: $GITLAB_API_TOKEN" "$GITLAB_HOST/api/v4/projects/$GITLAB_USER%2f$GITLAB_PROJECT/variables" --form "key=AWS_ACCESS_KEY_ID" --form "value=$AWS_ACCESS_KEY_ID"
curl --request POST -sSLk --header "PRIVATE-TOKEN: $GITLAB_API_TOKEN" "$GITLAB_HOST/api/v4/projects/$GITLAB_USER%2f$GITLAB_PROJECT/variables" --form "key=AWS_SECRET_ACCESS_KEY" --form "value=$AWS_SECRET_ACCESS_KEY"
curl --request POST -sSLk --header "PRIVATE-TOKEN: $GITLAB_API_TOKEN" "$GITLAB_HOST/api/v4/projects/$GITLAB_USER%2f$GITLAB_PROJECT/variables" --form "key=AWS_REGION" --form "value=$AWS_REGION"
curl --request POST -sSLk --header "PRIVATE-TOKEN: $GITLAB_API_TOKEN" "$GITLAB_HOST/api/v4/projects/$GITLAB_USER%2f$GITLAB_PROJECT/variables" --form "key=AWS_BUCKET" --form "value=$AWS_BUCKET"
