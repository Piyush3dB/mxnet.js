# MXNet checkout directory
ifndef MXNET
	MXNET=mxnet
endif

# Use locally installed emscripten if not specified
#EMCC=docker run -v ${PWD}:/src apiaryio/emcc emcc
#ifndef EMCC
#    EMCC=emcc
#endif

.PHONY: rebuild

# This script syncs libmxnet_predict.js from mxnet repo
# This should rarely be ran, as long as the predictor works
# Type make rebuild

rebuild:
	echo "Rebuild libmxnet_predict.js from MXNet with emscripten"
	cd $(MXNET)/amalgamation/
	make clean libmxnet_predict.js MIN=1 EMCC="docker run -v ${PWD}:/src apiaryio/emcc emcc"
	cd -
	cp $(MXNET)/amalgamation/libmxnet_predict.js* .
