exports.up = function(knex, Promise) {
	return knex.schema.createTable('table-1', table => {
		table.increments().primary();

		table.string('name').notNullable();
		table.string('description');

		table.timestamp('created_at').defaultTo(knex.fn.now())
	});
};

exports.down = function(knex, Promise) {
	return knex.schema.dropTable('table-1');
};
