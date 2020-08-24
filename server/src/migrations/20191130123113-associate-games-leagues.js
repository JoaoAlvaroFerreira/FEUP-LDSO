"use strict";

module.exports = {
  up: (queryInterface, Sequelize) => {
    return queryInterface.createTable("GameLeagues", {
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE
      },
      GameId: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        onUpdate: "CASCADE",
        onDelete: "CASCADE"
      },
      LeagueId: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        onUpdate: "CASCADE",
        onDelete: "CASCADE"
      }
    });
  },

  down: (queryInterface, Sequelize) => {
    return queryInterface.dropTable("GameLeagues");
  }
};
