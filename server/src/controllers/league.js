import model from "../models";

const { League } = model;
class Leagues {
  static all() {
    return League.findAll({
      include: [
        {
          model: model.User,
          as: "Creator",
          attributes: ["username"]
        }
      ]
    });
  }

  static create(newLeague) {
    return League.create(newLeague);
  }

  static update(id, newLeague) {
    return League.update(newLeague, { where: { id } });
  }

  static findById(id) {
    return League.findByPk(id, {
      include: [
        {
          model: model.User,
          as: "Creator",
          attributes: ["username"]
        }
      ]
    });
  }

  static deleteById(id) {
    return League.destroy({ where: { id } });
  }
}

export default Leagues;
