import model from "../models";

const { Invite } = model;
class Invites {
  static all() {
    return Invite.findAll();
  }

  static create(newInvite) {
    return Invite.create(newInvite);
  }

  static update(id, newInvite) {
    return Invite.update(newInvite, { where: { id } });
  }

  static findById(id) {
    return Invite.findByPk(id);
  }

  static findByInvitesReceived(user) {
    return Invite.findAll({
      where: { InviteReceivedId: user }
    });
  }

  static findByInvitesSent(user) {
    return Invite.findAll({
      where: { InviteSentId: user }
    });
  }

  static deleteById(id) {
    return Invite.destroy({ where: { id } });
  }
}

export default Invites;
