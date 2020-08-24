export default (sequelize, DataTypes) => {
  const League = sequelize.define(
    "League",
    {
      name: {
        type: DataTypes.STRING,
        allowNull: { args: false, msg: "Please enter a league name" }
      },
      competition: {
        type: DataTypes.ENUM({
          values: ["NBA"]
        }),
        allowNull: { args: false, msg: "Please enter a competition" }
      }
    },
    {}
  );
  League.associate = function(models) {
    League.belongsTo(models.User, { as: "Creator" });
    // A league belongs to many users
    League.belongsToMany(models.User, {
      through: "UserLeagues"
    });
    // One league can have many games
    League.belongsToMany(models.Game, {
      through: "GameLeagues"
    });
    League.hasMany(models.Bet);
    League.hasMany(models.Invite);
  };
  return League;
};
