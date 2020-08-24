"use strict";

module.exports = {
  up: (queryInterface, Sequelize) => {
    return queryInterface.createTable("UserFriends", {
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
      FriendId: {
        type: Sequelize.UUID,
        primaryKey: true,
        onUpdate: "CASCADE",
        onDelete: "CASCADE"
      }
    });
  },

  down: (queryInterface, Sequelize) => {
    return queryInterface.dropTable("UserFriends");
  }
};
