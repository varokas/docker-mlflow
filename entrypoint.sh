#!/bin/bash

if [ "$BACKEND" == "postgres" ]; then

  if [ -z "$POSTGRES_HOST" ]; then
    echo POSTGRES_HOST not defined
    exit -1
  fi
  if [ -z "$POSTGRES_PORT" ]; then
    echo POSTGRES_PORT not defined
    exit -1
  fi
  if [ -z "$POSTGRES_DATABASE" ]; then
    echo POSTGRES_DATABASE not defined
    exit -1
  fi
  if [ -z "$POSTGRES_USERNAME" ]; then
    echo POSTGRES_USERNAME not defined
    exit -1
  fi
  if [ -z "$POSTGRES_PASSWORD" ]; then
    echo POSTGRES_PASSWORD not defined
    exit -1
  fi

  if [ -z "$DEFAULT_ARTIFACT_ROOT" ]; then
    echo DEFAULT_ARTIFACT_ROOT not defined
    exit -1
  fi

  BACKEND_STORE_URI=postgresql://$POSTGRES_USERNAME:$POSTGRES_PASSWORD@$POSTGRES_HOST:$POSTGRES_PORT/$POSTGRES_DATABASE
fi

if [ -n "$DEFAULT_ARTIFACT_ROOT" ]; then
  if [ -z "$AWS_ACCESS_KEY_ID" ]; then
    echo AWS_ACCESS_KEY_ID not defined
    exit -1
  fi
  if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
    echo AWS_SECRET_ACCESS_KEY not defined
    exit -1
  fi

  # Check AWS permission
  echo "Checking access to : $DEFAULT_ARTIFACT_ROOT"
  aws s3 ls $DEFAULT_ARTIFACT_ROOT/
  if [ $? -ne 0 ]; then
    echo "Cannot access $DEFAULT_ARTIFACT_ROOT"
    exit -2
  fi
fi

ARGS="-h 0.0.0.0 -p 8000"
if [ -n "$DEFAULT_ARTIFACT_ROOT" ]; then
  ARGS="$ARGS --default-artifact-root $DEFAULT_ARTIFACT_ROOT"
fi

if [ "$BACKEND" == "postgres" ]; then
  ARGS="$ARGS --backend-store-uri $BACKEND_STORE_URI"
fi

mlflow server $ARGS
