#!/usr/bin/env bash
script_name=$0

USAGE ()
{
    echo "Download model from DMLC Model Gallery and prepare into JSON format for JS model"
    echo "${script_name} [-squeezenet] [-nin] [-caffenet] [-resnet] [-inceptionbn]"
}

while [ "$1" != "" ]; do
  case $1 in
    -help)
      USAGE
      exit 0;;
      -all | -inceptionbn | -squeezenet | -nin | -caffenet | -resnet)
      TYPE=${1:1};;
  esac
  shift
done

echo $TYPE

if [ ! "$TYPE" ]; then
  echo "You must specify a test type"
  USAGE
  exit 0
fi


case $TYPE in
  all)
    echo "all";;
  nin)
    echo "nin";;
  inceptionbn)
    echo "inceptionBN";;
  squeezenet)
    echo "squeezenet";;
  resnet)
    echo "resnet";;
  caffenet)
    echo "caffenet";;
esac


exit 0




THIS_DIR=$(cd `dirname $0`; pwd)
DATA_DIR="${THIS_DIR}/data/"

if [[ ! -d "${DATA_DIR}" ]]; then
  echo "${DATA_DIR} doesn't exist, will create one";
  mkdir -p ${DATA_DIR}
fi
cd ${DATA_DIR}


get_cat_image(){
	# Get cat image
	wget --no-check-certificate https://raw.githubusercontent.com/dmlc/mxnet.js/master/data/cat.png;
}


prep_json_for_js(){
	# Create Symbol + params file for JSON
	cp Inception-BN-symbol.json ./Inception-BN-symbol-js.json
	sed -i '1s/^/{\n"symbol":\n/' ./Inception-BN-symbol-js.json
	sed -i '$s/$/,/' ./Inception-BN-symbol-js.json
	echo -en "\n" >> ./Inception-BN-symbol-js.json
	cat synset.txt | sed 's/.*/"&",/' | tr '\n' ' ' | sed 's/.*/"synset": [&],/' | sed 's/, ],/],/g' >> ./Inception-BN-symbol-js.json
	echo -en "\n" >> ./Inception-BN-symbol-js.json
	base64 -w 0 Inception-BN-0126.params | sed 's/.*/"parambase64": "&"/' >> ./Inception-BN-symbol-js.json
	echo -en "\n" >> ./Inception-BN-symbol-js.json
	echo } >> ./Inception-BN-symbol-js.json
}


prep_inception_model(){
	# Get inception model
	wget --no-check-certificate http://data.dmlc.ml/mxnet/models/imagenet/inception-bn.tar.gz;
	tar -zxvf inception-bn.tar.gz
	prep_json_for_js
}


#get_cat_image
prep_inception_model
