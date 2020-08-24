"use strict";

module.exports = {
  up: (queryInterface, Sequelize) => {
    return queryInterface.createTable("UserLeagues", {
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE
      },
      UserId: {
        type: Sequelize.UUID,
        primaryKey: true,
        onUpdate: "CASCADE",
        onDelete: "CASCADE"
      },
      LeagueId: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        onUpdate: "CASCADE",
        onDelete: "CASCADE"
      },
      points: {
        type: Sequelize.INTEGER,
        defaultValue: 0
      },
      rank: {
        type: Sequelize.INTEGER,
        defaultValue: 0
      }
    });
  },

  down: (queryInterface, Sequelize) => {
    return queryInterface.dropTable("UserLeagues");
  }
};
