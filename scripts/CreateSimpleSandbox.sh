#!/bin/bash

# Mandatory parameter for project name
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <ProjectName>"
    exit 1
fi
PROJECT_NAME=$1

# Store the current directory and change to the script's directory
LF=$(pwd)
cd "$(dirname "$0")"

# Delete any .apax folders from ../src/templates.simple/
find ../src/templates.simple/ -type d -name ".apax" -exec rm -rf {} +

# Installing the .NET template
dotnet new install ../src/templates.simple/ --force

# Creating a new project with the provided name
dotnet new axosimple -n $PROJECT_NAME -o ../src/sandbox

# Delete files starting with 'tmp_sol_' from the ../src/sandbox directory
rm -f ../src/sandbox/tmp_*_.*

echo "Project $PROJECT_NAME created successfully."

# Return to the original directory
cd "$LF"
