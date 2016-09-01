#!/bin/bash

if ! type phantomjs > /dev/null; then
  echo 'PhantomJS was not found - installing...'
  sudo npm install --global phantomjs-prebuilt@2.1.7
fi

if ! type wraith > /dev/null || ! wraith; then
  echo 'Wraith was not found installing...'
  sudo gem install wraith -v 3.2.1
fi

git checkout master

cd test/wraith
wraith history configs/history.yaml

git checkout -

wraith latest configs/history.yaml
cd ../../
