"use strict";
const vsda_location = 'C:\\Users\\egorbychin\\AppData\\Local\\Programs\\Microsoft VS Code\\resources\\app\\node_modules.asar.unpacked\\vsda\\build\\Release\\vsda.node';
const a = require(vsda_location);
const signer = new a.signer();
process.argv.forEach((value, index, array) => {
    if (index >= 2) {
        const r = signer.sign(value);
        console.log(r);
    }
});
