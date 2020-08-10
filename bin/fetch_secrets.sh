#!/bin/sh

# Premise intalled below commands:
1. gcloud(https://cloud.google.com/sdk/install?hl=en)
2. jq(https://github.com/stedolan/jq)

# Get secrets list
secrets=$(gcloud secrets list --format=json | jq -r '.[].name')

# Get secret values
for path in ${secrets[@]}; do
	secret_name=$( awk -F'/' '{print $4}' <<< ${path} )
	if value=$(gcloud secrets versions access latest --secret=${secret_name}); then
		if [ ! -f .env ]; then
			touch .env
			echo '.env file created'
		fi
		target=$secret_name; command=/^$target=/d; sed -i '' $command .env
		echo $secret_name=$value >> .env
	fi
done
