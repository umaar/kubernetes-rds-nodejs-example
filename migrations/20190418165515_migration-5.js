exports.up = function (knex) {
	return knex.schema.dropTable('table-1');
};

exports.down = function () {};
