require('dotenv').config();

const {
	DATABASE_USERNAME,
	DATABASE_PASSWORD,
	// RDS_INSTANCE_ENDPOINT,
	DATABASE_NAME,
	RDS_INSTANCE_ADDRESS
} = process.env;

console.log(`\nDatabase username: ${DATABASE_USERNAME}`);

module.exports = {

	development: {
		client: 'postgresql',
		connection: {
			host: RDS_INSTANCE_ADDRESS,
			database: DATABASE_NAME,
			user: DATABASE_USERNAME,
			password: DATABASE_PASSWORD
		},
		pool: {
			min: 2,
			max: 10
		},
		migrations: {
			tableName: 'knex_migrations'
		}
	}

};
