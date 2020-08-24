import model from "../models";

const { Bet } = model;
class Bets {
  static all() {
    return Bet.findAll({
      include: [{ model: model.User, attributes: ["id", "username"] }]
    });
  }

  static findById(bet) {
    return Bet.findByPk(bet, {
      include: [{ model: model.User, attributes: ["id", "username"] }]
    });
  }

  static findByUser(user) {
    return Bet.findAll({
      where: { UserId: user }
    });
  }

  static create(newBet) {
    return Bet.create(newBet);
  }

  static update(id, newBet) {
    return Bet.update(newBet, { where: { id } });
  }

  static deleteById(id) {
    return Bet.destroy({ where: { id } });
  }
}

export default Bets;
