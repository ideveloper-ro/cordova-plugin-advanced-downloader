/*
 * A native Downloader Plugin for Cordova / PhoneGap.
 */

var exec = require('cordova/exec');


module.exports = {

	downloadFile: function(url, filePath, success, failure) {
		return exec(success, failure, 'CordovaDownloaderPlugin', 'downloadFile', [url, filePath]);
	}

};