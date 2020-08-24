"use strict";
module.exports = {
  up: (queryInterface, Sequelize) => {
    return queryInterface.createTable("Invites", {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      date: {
        allowNull: false,
        type: Sequelize.DATE,
        defaultValue: new Date()
      },
      InviteReceivedId: {
        type: Sequelize.UUID,
        primaryKey: true,
        onUpdate: "CASCADE",
        onDelete: "CASCADE"
      },
      InviteSentId: {
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
    return queryInterface.dropTable("Invites");
  }
};
