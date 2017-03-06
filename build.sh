
# MXNet checkout directory
MXNET=mxnet

# Build
echo "Rebuild libmxnet_predict.js from MXNet with emscripten"
rm -rf libmxnet_predict.js*
cd ${MXNET}
#git submodule update --init --recursive
cd ${MXNET}/amalgamation/
make clean libmxnet_predict.js MIN=1 EMCC="docker run -v ${PWD}:/src apiaryio/emcc emcc"
cd -
cp ${MXNET}/amalgamation/libmxnet_predict.js* .
