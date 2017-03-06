
# MXNet checkout directory
MXNET=mxnet

# Emscripten executable
#EMCC="docker run -v ${PWD}:/src apiaryio/emcc emcc"

# Build
echo "Rebuild libmxnet_predict.js from MXNet with emscripten"
cd ${MXNET}
git checkout 33930c6b89314739f4f39c3fd642db5e024b8dc2
git submodule update --init --recursive
cd ${MXNET}/amalgamation/
make clean libmxnet_predict.js MIN=1 EMCC="docker run -v ${PWD}:/src apiaryio/emcc emcc"
#make clean libmxnet_predict.js MIN=1 EMCC=$EMCC
cd -
cp ${MXNET}/amalgamation/libmxnet_predict.js* .