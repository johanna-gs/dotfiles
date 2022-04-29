#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title SSO Login
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description Login to AWS with SSO Login
# @raycast.author Anders Kirkeby

aws sso login --profile sso-dev-eks
