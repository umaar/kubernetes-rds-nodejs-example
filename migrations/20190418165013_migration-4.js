exports.up = function(knex, Promise) {
	return knex.schema.alterTable('table-1', async table => {
		await table.dropColumn('id');
		await table.increments();
	});
};

exports.down = function(knex, Promise) {
};
