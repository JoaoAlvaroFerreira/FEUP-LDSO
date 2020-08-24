"use strict";
module.exports = {
  up: (queryInterface, Sequelize) => {
    return queryInterface.createTable("Games", {
      id: {
        primaryKey: true,
        allowNull: false,
        type: Sequelize.INTEGER,
        autoIncrement: true
      },
      GameID: {
        type: Sequelize.INTEGER,
        allowNull: { args: false, msg: "Please enter a game id" }
      },
      Season: Sequelize.INTEGER,
      Status: {
        type: Sequelize.STRING,
        allowNull: { args: false, msg: "Please enter a status" }
      },
      DateTime: {
        type: Sequelize.DATE,
        allowNull: { args: false, msg: "Please enter a date time" }
      },
      AwayTeam: {
        type: Sequelize.STRING,
        allowNull: { args: false, msg: "Please enter a away team" }
      },
      HomeTeam: {
        type: Sequelize.STRING,
        allowNull: { args: false, msg: "Please enter a home team" }
      },
      AwayTeamID: Sequelize.INTEGER,
      HomeTeamID: Sequelize.INTEGER,
      StadiumID: Sequelize.INTEGER,
      Stadium: Sequelize.STRING,
      AwayTeamScore: {
        type: Sequelize.INTEGER,
        defaultValue: 0
      },
      HomeTeamScore: {
        type: Sequelize.INTEGER,
        defaultValue: 0
      },
      IsClosed: Sequelize.BOOLEAN,
      GameEndDateTime: Sequelize.DATE,
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
    return queryInterface.dropTable("Games");
  }
};
