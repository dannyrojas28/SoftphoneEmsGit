#!/usr/bin/env node
'use strict';

let cwd = process.cwd();
let fs = require('fs');
let path = require('path');

console.log('InstagramAssetsPicker AfterPluginInstall.js, attempting to modify build.xcconfig');

let xcConfigBuildFilePath = path.join(cwd, 'platforms', 'ios', 'cordova', 'build.xcconfig');
console.log('xcConfigBuildFilePath: ', xcConfigBuildFilePath);
let lines = fs.readFileSync(xcConfigBuildFilePath, 'utf8').split('\n');

let headerSearchPathLineNumber;
lines.forEach((l, i) => {
              if (l.indexOf('HEADER_SEARCH_PATHS') > -1) {
              headerSearchPathLineNumber = i;
              }
              });

lines[headerSearchPathLineNumber] += ' "$(SRCROOT)/$(PRODUCT_NAME)/Plugins/com.techstorm.linphone/liblinphone-sdk/apple-darwin/include"';

let newConfig = lines.join('\n');

fs.writeFile(xcConfigBuildFilePath, newConfig, function (err) {
             if (err) {
             console.log('error updating build.xcconfig, err: ', err);
             return;
             }
             console.log('successfully updated HEADER_SEARCH_PATHS in build.xcconfig');
             });


var filestocopy = [{
                   "src/ios/include/antlr3.h":
                   "platforms/ios/antlr3.h"
                   } ];

// no need to configure below
var rootdir = cwd;

filestocopy.forEach(function(obj) {
                    Object.keys(obj).forEach(function(key) {
                                             var val = obj[key];
                                             var srcfile = path.join(rootdir, key);
                                             var destfile = path.join(rootdir, val);
                                             console.log("copying "+srcfile+" to "+destfile);
                                             var destdir = path.dirname(destfile);
                                             if (fs.existsSync(srcfile) && fs.existsSync(destdir)) {
                                             fs.createReadStream(srcfile).pipe(
                                                                               fs.createWriteStream(destfile));
                                             }
                                             });
                    });