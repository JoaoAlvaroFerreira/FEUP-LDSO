"use strict";
module.exports = {
  up: (queryInterface, Sequelize) => {
    return queryInterface
      .createTable("Users", {
        id: {
          primaryKey: true,
          allowNull: false,
          type: Sequelize.UUID,
          defaultVlaue: Sequelize.UUIDV4
        },
        name: {
          type: Sequelize.STRING,
          allowNull: { args: false, msg: "Please enter your name" },
          validate: {
            len: {
              args: [2, 42],
              msg: "The name length should be between 2 and 42 characters."
            }
          }
        },
        username: {
          type: Sequelize.STRING,
          allowNull: { args: false, msg: "Please enter your username" },
          validate: {
            len: {
              args: [3, 20],
              msg: "The username length should be between 3 and 20 characters."
            }
          }
        },
        photoUrl: {
          type: Sequelize.STRING,
          validate: {
            isUrl: true
          }
        },
        email: {
          type: Sequelize.STRING,
          allowNull: { args: false, msg: "Please enter your email address" },
          validate: {
            isEmail: { args: true, msg: "Please enter a valid email address" }
          },
          unique: { args: true, msg: "Email already exists" }
        },
        password: {
          type: Sequelize.STRING,
          allowNull: { args: false, msg: "Please enter a password" },
          validate: {
            len: {
              args: [7, 42],
              msg: "The password length should be between 7 and 42 characters."
            }
          }
        },
        createdAt: {
          allowNull: false,
          type: Sequelize.DATE
        },
        updatedAt: {
          allowNull: false,
          type: Sequelize.DATE
        }
      })
      .then(() => {
        queryInterface.addIndex("Users", ["email"], {
          unique: true
        });
      });
  },
  down: (queryInterface, Sequelize) => {
    return queryInterface.dropTable("Users");
  }
};
