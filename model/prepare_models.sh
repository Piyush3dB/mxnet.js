#!/usr/bin/env bash
script_name=$0

USAGE (){
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

#prep_json_for_js(){
#  # To call function
#  #prep_json_for_js Inception-BN-symbol Inception-BN-0126.params
#
#  symbolName=$1".json"
#  jsName=$1"-js.json"
#  paramsFile=$2
#
#  # Create Symbol + params file for JSON
#  cp $symbolName $jsName
#  sed -i '1s/^/{\n"symbol":\n/' $jsName
#  sed -i '$s/$/,/' $jsName
#  echo -en "\n" >> $jsName
#  cat synset.txt | sed 's/.*/"&",/' | tr '\n' ' ' | sed 's/.*/"synset": [&],/' | sed 's/, ],/],/g' >> $jsName
#  echo -en "\n" >> $jsName
#  base64 -w 0 $paramsFile | sed 's/.*/"parambase64": "&"/' >> $jsName
#  echo -en "\n" >> $jsName
#  echo } >> $jsName
#}

prep_squeezenet_model(){
  echo "Preparing squeezenet model..."

  echo "    Downloading model from gallery..."
  wget --no-check-certificate http://data.dmlc.ml/mxnet/models/imagenet/inception-bn.tar.gz
  tar -zxvf inception-bn.tar.gz

  echo "   Running python script to generate json model for JS..."
  python ../tools/model2json.py Inception-BN-symbol-js.json Inception-BN-symbol.json Inception-BN-0126.params synset.txt

}

prep_inception_model(){
  echo "Preparing inceptionbn model..."

  echo "    Downloading inception model from gallery..."
  wget --no-check-certificate http://data.dmlc.ml/mxnet/models/imagenet/inception-bn.tar.gz
  tar -zxvf inception-bn.tar.gz

  echo "   Running python script to generate json model for JS..."
  python ../../tools/model2json.py Inception-BN-symbol-js.json Inception-BN-symbol.json Inception-BN-0126.params synset.txt

  echo "   Cleaning..."
  cp Inception-BN-symbol-js.json ..
  cd ..
  rm -rf temp
}


#
# Parse command-line arguments
#
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

if [ ! "$TYPE" ]; then
  echo "You must specify a test type"
  USAGE
  exit 0
fi


#
# Create temp dir
#
THIS_DIR=$(cd `dirname $0`; pwd)
DATA_DIR="${THIS_DIR}/temp/"

if [[ ! -d "${DATA_DIR}" ]]; then
  echo "${DATA_DIR} doesn't exist, will create one";
  mkdir -p ${DATA_DIR}
fi
cd ${DATA_DIR}

#
# Prepare models
#
case $TYPE in
  all)
    echo "Preparing all models..."
    prep_inception_model
    ;;
  nin)
    echo "Preparing nin model..."
    ;;
  inceptionbn)
    prep_inception_model
    ;;
  squeezenet)
    echo "Preparing squeezenet model..."
    ;;
  resnet)
    echo "Preparing resnet model..."
    ;;
  caffenet)
    echo "Preparing caffenet model..."
    ;;
esac
