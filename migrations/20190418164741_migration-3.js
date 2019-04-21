exports.up = function (knex) {
	return knex.schema.alterTable('table-1', async table => {
		await table.string('name').notNullable();
	});
};

exports.down = function () {};
