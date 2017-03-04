#!/usr/bin/env bash

THIS_DIR=$(cd `dirname $0`; pwd)
#DATA_DIR="${THIS_DIR}/data/"

#if [[ ! -d "${DATA_DIR}" ]]; then
#  echo "${DATA_DIR} doesn't exist, will create one";
#  mkdir -p ${DATA_DIR}
#fi
#cd ${DATA_DIR}

# Get cat image
#wget --no-check-certificate https://raw.githubusercontent.com/dmlc/mxnet.js/master/data/cat.png;

# Get inception model
#wget http://data.dmlc.ml/mxnet/models/imagenet/squeezenet/squeezenet_v1.0.tar.gz
#tar -zxvf squeezenet_v1.0.tar.gz

# wget -m -p -E -k -K -np http://data.dmlc.ml/models/imagenet/squeezenet/



#squeezenet_v1.0-0000.params
#squeezenet_v1.0-symbol.json

startFile=squeezenet_v1.0-symbol.json
endFile=./squeezenet_v1.0-symbol-js.json

# Create Symbol + params file for JSON
cp $startFile $endFile
sed -i '1s/^/{\n"symbol":\n/' $endFile
sed -i '$s/$/,/' $endFile
echo -en "\n" >> $endFile
cat ./data/synset.txt | sed 's/.*/"&",/' | tr '\n' ' ' | sed 's/.*/"synset": [&],/' | sed 's/, ],/],/g' >> $endFile
echo -en "\n" >> $endFile
base64 -w 0 squeezenet_v1.0-0000.params | sed 's/.*/"parambase64": "&"/' >> $endFile
echo -en "\n" >> $endFile
echo } >> $endFile