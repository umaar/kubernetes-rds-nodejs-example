require('dotenv').config()

var express = require('express');
const os = require('os');

const defaultKnexfileConfig = require('./knexfile.js')['development'];

const knexConfig = {
	...defaultKnexfileConfig,
	// debug: true,
	acquireConnectionTimeout: 2000
}

const db = require('knex')(knexConfig);

var DEFAULT_PORT = process.env.PORT || 3000;

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
		const userAgent = req.headers['user-agent'];
		await db('views').insert({
			user_agent: userAgent
		});

		const [{count}] = await db('views').count('id');
		const message = `Session ${requestCount} out of ${count} of all time!\n`;
		requestCount++;
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

start().catch(err => {
	console.log('There was an error\n\n', err, '\n\nExiting...\n\n');
	process.exit(1);
});