var mx = require("./mxnet_predict.js");
var model = require("./model/fastpoor.json");
var model = require("./model/inception-bn-model.json");
var model = require("./model/data/Inception-BN-symbol-js.json");
var cat_encoded = require("./data/cat.base64.json");
var decode = mx.base64Decode(cat_encoded);
var decoded = new Float32Array(decode.buffer);
var cat = mx.ndarray(decoded, [1, 3, 224, 224]);

pred = new mx.Predictor(model, {'data': [1, 3, 224, 224]});
pred.setinput('data', cat);
console.log("Here");
var nleft = 1;
for (var step = 0; nleft != 0; ++step) {
  nleft = pred.partialforward(step);
  console.log("progress " + (step+1) + "/" + (nleft+step+1));
}
out = pred.output(0);

console.log("finished prediction....");
out = pred.output(0);
var index = new Array();
for (var i=0;i<out.data.length;i++) {
	index[i] = i;
}
max_output = 10;
console.log("Max output = " + max_output);
index.sort(function(a,b) {return out.data[b]-out.data[a];});
//var end = new Date().getTime();
//var time = (end - start) / 1000;
//console.log("time-cost=" + time + " sec");
for (var i = 0; i < max_output; i++) {
	//console.log('Top-' + (i+1) + ':' + model.synset[index[i]] + ', value=' + out.data[index[i]]);
	console.log("Top-%d: %s, value=%f", (i+1), model.synset[index[i]], out.data[index[i]]);
}


pred.destroy();

//   docker run -it --rm --name my-running-script -v "$PWD":/usr/src/app -w /usr/src/app node:4 node test_on_node.js
