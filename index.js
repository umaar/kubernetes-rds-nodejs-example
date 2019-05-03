require('dotenv').config();

const os = require('os');
const express = require('express');
const knex = require('knex');

const defaultKnexfileConfig = require('./knexfile.js').development;

const knexConfig = {
	...defaultKnexfileConfig,
	// Debug: true,
	acquireConnectionTimeout: 2000
};

const db = knex(knexConfig);

const DEFAULT_PORT = process.env.PORT || 3000;

function logUsefulInfo() {
	const hostname = os.hostname();
	const platform = os.platform();
	const userInfo = os.userInfo();

	console.log('\n---');
	console.log(`Current Hostname: ${hostname}`);
	console.log(`Current platform: ${platform}`);
	console.log('User Info:', userInfo);
	console.log('---\n');
}

function createExpresServer(port) {
	const app = express();
	app.listen(port);

	console.log('Express Web Server Running on http://localhost:' + port);
	return app;
}

function registerAppRoutes({app}) {
	let requestCount = 0;

	app.get('/', async (req, res) => {
		requestCount++;

		const userAgent = req.headers['user-agent'];

		await db('views').insert({
			/* eslint camelcase: "off" */
			user_agent: userAgent
		});

		const [{count}] = await db('views').count('id');
		const message = `${requestCount} page views since last app restart. ${count} views of all time ✨️\n`;

		console.log(message);
		res.send(message);
	});
}

async function start() {
	logUsefulInfo();

	const app = createExpresServer(DEFAULT_PORT);

	registerAppRoutes({
		app
	});
}

start().catch(error => {
	console.log('There was an error\n\n', error, '\n\nExiting...\n\n');
	throw new Error(error);
});
