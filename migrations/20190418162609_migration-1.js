exports.up = function (knex) {
	return knex.schema.createTable('table-1', table => {
		table.integer('id').unique().primary();

		table.timestamp('name').notNullable();
		table.string('description');

		table.timestamp('created_at').defaultTo(knex.fn.now());
	});
};

exports.down = function (knex) {
	return knex.schema.dropTable('table-1');
};
