#!/bin/bash

echo 'removing temp'
rm -rf temp

echo 'creating temp'
mkdir temp

echo 'downloading latest hub release'
wget https://github.com/ironman9967/iron-iot-hub/archive/latest.tar.gz

echo 'extracting release'
tar xvzf latest.tar.gz --transform 's/iron-iot-hub-latest/temp/'

echo 'removing release tar'
rm latest.tar.gz

echo 'starting nvm'
source ./common/scripts/start-nvm.sh hub

echo 'getting node version from cloud'
nodeVersion=`wget -qO- http://iron-iot-cloud:9967/api/code/versions/node | grep -o ':".*' | grep -o '[^:"} ]*'`
echo "node version is $nodeVersion"

echo "installing node $nodeVersion"
`nvm install $nodeVersion`

echo "setting nvm default to $nodeVersion"
`nvm alias default $nodeVersion`

echo "setting nvm to use $nodeVersion"
`nvm use $nodeVersion`

echo 'navigating to temp'
cd temp

echo 'npm install all deps'
npm i

echo 'building app'
npm run build

echo 'navigate up from temp'
cd ..

echo 'copying dist'
cp -r ./temp/dist ./
echo 'copying package.json'
cp ./temp/package.json ./
echo 'copying package-lock.json'
cp ./temp/package-lock.json ./

echo 'removing temp'
rm -rf temp

echo 'npm install production deps'
npm i --production
