exports.up = function (knex) {
	return knex.schema.createTable('views', table => {
		table.increments().primary();

		table.string('user_agent').notNullable();

		table.timestamp('created_at').defaultTo(knex.fn.now());
	});
};

exports.down = function (knex) {
	return knex.schema.dropTable('views');
};
