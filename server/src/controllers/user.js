import model from "../models";
const Sequelize = require("sequelize");
const Op = Sequelize.Op;

const { User } = model;
class Users {
  static all() {
    return User.findAll({
      include: [{ model: model.Bet, attributes: ["id", "points"] }]
    });
  }

  static others(userId) {
    return User.findAll({
      where: {
        id: {
          [Op.not]: userId // id NOT userId
        }
      }
    });
  }

  static create(newUser) {
    return User.create(newUser);
  }

  static update(id, newUser) {
    return User.update(newUser, { where: { id } });
  }

  static findById(id) {
    return User.findByPk(id, {
      include: [{ model: model.Bet, attributes: ["id", "points"] }]
    });
  }

  static findByEmail(email) {
    return User.findOne({
      where: { email },
      include: [{ model: model.Bet, attributes: ["id", "points"] }]
    });
  }

  static deleteById(id) {
    return User.destroy({ where: { id } });
  }
}

export default Users;
