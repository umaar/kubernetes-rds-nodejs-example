exports.up = function(knex, Promise) {
	return knex.schema.dropTable('table-1');

};

exports.down = function(knex, Promise) {
};
