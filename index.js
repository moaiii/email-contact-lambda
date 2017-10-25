'use strict';
console.log('Loading function');
var AWS = require('aws-sdk')
AWS.config.region = 'eu-west-1';
var ses = new AWS.SES()

var RECEIVER = 'christopher.melville@me.com'
var SENDER = 'VERIFIED_EMAIL@example.com'

exports.handler = function (event, context) {

	sendEmail(event, function (err, data) {
		context.done(err, null)
	})
}

function sendEmail (event, done) {
	var params = {
		Destination: {
			ToAddresses: [
				RECEIVER
			]
		},
		Message: {
			Body: {
				Text: {
					Data: JSON.stringify(event, null, 2),
					Charset: 'UTF-8'
				}
			},
			Subject: {
				Data: 'New Contact from WEBSITE',
				Charset: 'UTF-8'
			}
		},
		Source: SENDER
	}
	ses.sendEmail(params, done)
}