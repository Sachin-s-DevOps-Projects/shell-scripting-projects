#!/bin/bash

#######################################################################################
#Owner: R. Sachin Ayeshmantha
#About the script:  For printing editors those who can edit and read the repository of an organization
#Input: 1) Export username  ( ex: export userrname="Sachin20010517")
#       2)Export token    (ex: export token="ghp_Wr9H49RXASPpyBXbCcQwa8J")
#Requirements : 1)jq should be installed ( command for that : sudo apt install jq -y)
#               2) 2 arguments  should be given while running the file in the parameter. The parameters are
#               organization and repository name. ( ex: ./list-users.sh Sachin-s-DevOps-Projects shell-scripting-projects)
########################################################################################

helper()

# GitHub API URL
API_URL="https://api.github.com"

# GitHub username and personal access token
USERNAME=$username
TOKEN=$token

# User and Repository information
REPO_OWNER=$1
REPO_NAME=$2

# Function to make a GET request to the GitHub API
function github_api_get {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a GET request to the GitHub API with authentication
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# Function to list users with read access to the repository
function list_users_with_read_access {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

    # Fetch the list of collaborators on the repository
    collaborators="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')"

    # Display the list of collaborators with read access
    if [[ -z "$collaborators" ]]; then
        echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$collaborators"
    fi
}

#helper functions for input mistakes
function helper{
    expected_cmd_args=2
    if[ $# -ne $expected_cmd_args]; then
    echo "Please execute the script with required arguments"
    echo "asd"
}

# Main script

echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_users_with_read_access
