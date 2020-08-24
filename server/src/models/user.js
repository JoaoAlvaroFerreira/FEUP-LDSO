import bcrypt from "bcryptjs";
import uuid from "uuid/v4";

export default (sequelize, DataTypes) => {
  const User = sequelize.define(
    "User",
    {
      name: {
        type: DataTypes.STRING,
        allowNull: { args: false, msg: "Please enter your name" },
        validate: {
          len: {
            args: [2, 42],
            msg: "The name length should be between 2 and 42 characters."
          }
        }
      },
      username: {
        type: DataTypes.STRING,
        allowNull: { args: false, msg: "Please enter your username" },
        validate: {
          len: {
            args: [3, 20],
            msg: "The username length should be between 3 and 20 characters."
          }
        }
      },
      photoUrl: {
        type: DataTypes.STRING,
        validate: {
          isUrl: true
        }
      },
      email: {
        type: DataTypes.STRING,
        allowNull: { args: false, msg: "Please enter your email address" },
        validate: {
          isEmail: { args: true, msg: "Please enter a valid email address" }
        },
        unique: { args: true, msg: "Email already exists" }
      },
      password: {
        type: DataTypes.STRING,
        allowNull: { args: false, msg: "Please enter a password" },
        validate: {
          len: {
            args: [7, 42],
            msg: "The password length should be between 7 and 42 characters."
          }
        }
      }
    },
    { indexes: [{ unique: true, fields: ["email"] }] }
  );

  User.beforeCreate((user, _) => {
    return (user.id = uuid());
  });

  User.beforeSave((user, options) => {
    if (user.changed("password"))
      user.password = user.generateHash(user.password);
  });

  User.prototype.generateHash = function(pw) {
    return bcrypt.hashSync(pw, bcrypt.genSaltSync(), null);
  };

  User.prototype.validatePassword = function(pw) {
    return bcrypt.compare(pw, this.password);
  };

  User.associate = models => {
    // One user has many bets
    User.hasMany(models.Bet);
    User.hasMany(models.Invite, {
      foreignKey: "InviteReceivedId"
    });
    User.hasMany(models.Invite, {
      foreignKey: "InviteSentId"
    });
    //One user has many friends
    User.belongsToMany(models.User, {
      as: "User",
      through: "UserFriends",
      foreignKeyKey: "UserId"
    });
    User.belongsToMany(models.User, {
      as: "Friend",
      through: "UserFriends",
      foreignKey: "FriendId"
    });
    // One user can be in many leagues
    User.belongsToMany(models.League, {
      through: "UserLeagues"
    });
  };
  return User;
};
