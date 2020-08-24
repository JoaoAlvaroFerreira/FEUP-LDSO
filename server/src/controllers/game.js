import model from "../models";

const { Game } = model;
class Games {
  static all() {
    return Game.findAll();
  }

  static findById(game) {
    return Game.findByPk(game);
  }

  static findByGameId(gameId) {
    return Game.findOne({
      where: { GameID: gameId }
    });
  }

  static create(newGame) {
    return Game.create(newGame);
  }

  static update(id, newGame) {
    return Game.update(newGame, { where: { id } });
  }

  static deleteById(id) {
    return Game.destroy({ where: { id } });
  }
}

export default Games;
