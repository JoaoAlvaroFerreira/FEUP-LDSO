"use strict";
module.exports = {
  up: (queryInterface, Sequelize) => {
    return queryInterface.createTable("Leagues", {
      id: {
        primaryKey: true,
        allowNull: false,
        type: Sequelize.INTEGER,
        autoIncrement: true
      },
      name: {
        type: Sequelize.STRING,
        allowNull: { args: false, msg: "Please enter a league name" }
      },
      competition: {
        type: Sequelize.ENUM({
          values: ["NBA"]
        }),
        allowNull: { args: false, msg: "Please enter a competition" }
      },
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE
      },
      CreatorId: {
        allowNull: { args: false, msg: "League must have a creator" },
        type: Sequelize.UUID,
        onUpdate: "CASCADE",
        onDelete: "SET NULL"
      }
    });
  },
  down: (queryInterface, Sequelize) => {
    return queryInterface.dropTable("Leagues");
  }
};
