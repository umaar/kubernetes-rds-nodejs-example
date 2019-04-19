exports.up = function(knex, Promise) {
	return knex.schema.alterTable('table-1', async table => {
		await table.dropColumn('name');
		await table.string('name').notNullable();
	});
};

exports.down = function(knex, Promise) {
	return knex.schema.alterTable('table-1', async table => {
		await table.dropColumn('name');
		await table.timestamp('name').notNullable();
	});
};
