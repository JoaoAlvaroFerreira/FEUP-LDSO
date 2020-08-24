"use strict";
module.exports = {
  up: (queryInterface, Sequelize) => {
    return queryInterface.createTable("Bets", {
      id: {
        primaryKey: true,
        allowNull: false,
        type: Sequelize.INTEGER,
        autoIncrement: true
      },
      points: {
        type: Sequelize.INTEGER,
        defaultValue: 0
      },
      homeTeamScore: {
        type: Sequelize.INTEGER,
        defaultValue: 0
      },
      awayTeamScore: {
        type: Sequelize.INTEGER,
        defaultValue: 0
      },
      UserId: {
        type: Sequelize.UUID,
        references: {
          model: "Users",
          key: "id"
        },
        onUpdate: "CASCADE",
        onDelete: "CASCADE"
      },
      GameId: {
        type: Sequelize.INTEGER,
        references: {
          model: "Games",
          key: "id"
        },
        onUpdate: "CASCADE",
        onDelete: "CASCADE"
      },
      LeagueId: {
        type: Sequelize.INTEGER,
        references: {
          model: "Leagues",
          key: "id"
        },
        onUpdate: "CASCADE",
        onDelete: "CASCADE"
      },
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE
      }
    });
  },
  down: (queryInterface, Sequelize) => {
    return queryInterface.dropTable("Bets");
  }
};
