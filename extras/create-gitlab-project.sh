#!/usr/bin/env bash

# Uncomment the following and define proper values (or specify as environment variables)

GITLAB_HOST=devtools-gitlab.lab.devnetsandbox.local
GITLAB_USER=developer
GITLAB_PASSWORD=C1sco12345
GITLAB_PROJECT=mdd
CML_HOST=10.10.20.161
CML_USERNAME=developer
CML_PASSWORD=C1sco12345
CML_LAB=mdd
CML_VERIFY_CERT=false

# Add new project
curl --request POST -sSLk --header "PRIVATE-TOKEN: $GITLAB_API_TOKEN" "http://$GITLAB_HOST/api/v4/projects" --form "name=$GITLAB_PROJECT"

# Add new vars
curl --request POST -sSLk --header "PRIVATE-TOKEN: $GITLAB_API_TOKEN" "http://$GITLAB_HOST/api/v4/projects/$GITLAB_USER%2f$GITLAB_PROJECT/variables" --form "key=CML_HOST" --form "value=$CML_HOST"
curl --request POST -sSLk --header "PRIVATE-TOKEN: $GITLAB_API_TOKEN" "http://$GITLAB_HOST/api/v4/projects/$GITLAB_USER%2f$GITLAB_PROJECT/variables" --form "key=CML_USERNAME" --form "value=$CML_USERNAME"
curl --request POST -sSLk --header "PRIVATE-TOKEN: $GITLAB_API_TOKEN" "http://$GITLAB_HOST/api/v4/projects/$GITLAB_USER%2f$GITLAB_PROJECT/variables" --form "key=CML_PASSWORD" --form "value=$CML_PASSWORD"
curl --request POST -sSLk --header "PRIVATE-TOKEN: $GITLAB_API_TOKEN" "http://$GITLAB_HOST/api/v4/projects/$GITLAB_USER%2f$GITLAB_PROJECT/variables" --form "key=CML_LAB" --form "value=$CML_LAB"
curl --request POST -sSLk --header "PRIVATE-TOKEN: $GITLAB_API_TOKEN" "http://$GITLAB_HOST/api/v4/projects/$GITLAB_USER%2f$GITLAB_PROJECT/variables" --form "key=CML_VERIFY_CERT" --form "value=$CML_VERIFY_CERT"

# Push repo into project
git push http://$GITLAB_USER:$GITLAB_PASSWORD@$GITLAB_HOST/$GITLAB_USER/$GITLAB_PROJECT.git