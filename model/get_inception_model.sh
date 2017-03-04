#!/usr/bin/env bash
script_name=$0

USAGE ()
{
    echo "  "
    echo "  "
    echo "Script downloads model from the MXNet Model Gallery "
    echo "  and prepares a combined JSON file containing the  "
    echo "  computation graph and weights."
    echo "Usage:"
    echo "${script_name} [-squeezenet] [-nin] [-caffenet] [-resnet] [-inceptionbn]"
    echo "  "
    echo "  "
}


prep_json_for_js(){
  echo "Parameter #1 is $1"

  symbolName=$1".json"
  jsName=$1"-js.json"
  paramsFile=$2

  echo $symbolName
  echo $paramsFile

  #exit 0


  # Create Symbol + params file for JSON
  cp $symbolName $jsName
  sed -i '1s/^/{\n"symbol":\n/' $jsName
  sed -i '$s/$/,/' $jsName
  echo -en "\n" >> $jsName
  cat synset.txt | sed 's/.*/"&",/' | tr '\n' ' ' | sed 's/.*/"synset": [&],/' | sed 's/, ],/],/g' >> $jsName
  echo -en "\n" >> $jsName
  base64 -w 0 $paramsFile | sed 's/.*/"parambase64": "&"/' >> $jsName
  echo -en "\n" >> $jsName
  echo } >> $jsName
}

prep_inception_model(){
  # Get inception model

  wget --no-check-certificate http://data.dmlc.ml/mxnet/models/imagenet/inception-bn.tar.gz
  tar -zxvf inception-bn.tar.gz
  
  # Call function
  prep_json_for_js Inception-BN-symbol Inception-BN-0126.params
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


# Create data dir
THIS_DIR=$(cd `dirname $0`; pwd)
DATA_DIR="${THIS_DIR}/data/"

if [[ ! -d "${DATA_DIR}" ]]; then
  echo "${DATA_DIR} doesn't exist, will create one";
  mkdir -p ${DATA_DIR}
fi
cd ${DATA_DIR}




echo $TYPE

if [ ! "$TYPE" ]; then
  echo "You must specify a test type"
  USAGE
  exit 0
fi


case $TYPE in
  all)
    echo "Preparing all models...";;
  nin)
    echo "nin model...";;
  inceptionbn)
    echo "inceptionBN model..."
    prep_inception_model
    ;;
  squeezenet)
    echo "squeezenet model...";;
  resnet)
    echo "resnet model...";;
  caffenet)
    echo "caffenet model...";;
esac


#prep_json_for_js Inception-BN-symbol Inception-BN-0126.params





exit 0

get_cat_image(){
	# Get cat image
	wget --no-check-certificate https://raw.githubusercontent.com/dmlc/mxnet.js/master/data/cat.png;
}






#get_cat_image
prep_inception_model 
