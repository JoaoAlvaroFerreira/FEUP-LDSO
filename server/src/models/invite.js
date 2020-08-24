export default (sequelize, DataTypes) => {
  const Invite = sequelize.define(
    "Invite",
    {
      date: {
        type: DataTypes.DATE
      }
    },
    {}
  );
  Invite.associate = function(models) {
    Invite.belongsTo(models.League);
    Invite.belongsTo(models.User, {
      as: "InviteReceived",
      foreignKey: "InviteReceivedId"
    });
    Invite.belongsTo(models.User, {
      as: "InviteSent",
      foreignKey: "InviteSentId"
    });
  };
  return Invite;
};
