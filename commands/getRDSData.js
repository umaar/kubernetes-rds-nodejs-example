const shellExec = require('shell-exec')

function decodeBase64(encodedValue) {
	const buf = Buffer.from(encodedValue, 'base64');
	return buf.toString();
}

async function start() {
	const {stdout} = await shellExec('kubectl get secret umar-dev-rds-app-name -n umar-dev -o json');

	console.log(stdout, '\n');

	const myEncodedSecrets = JSON.parse(stdout).data;

	const secrets = {};

	[
		'database_username',
		'database_password',
		'rds_instance_endpoint',
		'database_name',
		'rds_instance_address'
	].map(property => {
		secrets[property] = decodeBase64(myEncodedSecrets[property])
	})

	console.log({secrets});

	const connectionString = `postgres://${secrets.database_username}:${secrets.database_password}@${secrets.rds_instance_endpoint}/${secrets.database_name}`;

	console.log('\n', connectionString);
}

start()