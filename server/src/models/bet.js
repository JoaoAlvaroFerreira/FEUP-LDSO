export default (sequelize, DataTypes) => {
  const Bet = sequelize.define(
    "Bet",
    {
      points: {
        type: DataTypes.INTEGER,
        defaultValue: 0
      },
      homeTeamScore: {
        type: DataTypes.INTEGER,
        defaultValue: 0
      },
      awayTeamScore: {
        type: DataTypes.INTEGER,
        defaultValue: 0
      },
      UserId: {
        type: DataTypes.UUID,
        references: {
          model: "Users",
          key: "id"
        },
        onUpdate: "CASCADE",
        onDelete: "CASCADE"
      },
      GameId: {
        type: DataTypes.INTEGER,
        references: {
          model: "Games",
          key: "id"
        },
        onUpdate: "CASCADE",
        onDelete: "CASCADE"
      },
      LeagueId: {
        type: DataTypes.INTEGER,
        references: {
          model: "Leagues",
          key: "id"
        },
        onUpdate: "CASCADE",
        onDelete: "CASCADE"
      }
    },
    {}
  );
  Bet.associate = function(models) {
    Bet.belongsTo(models.Game);
    // Each bet belongs to a user
    Bet.belongsTo(models.User);
    Bet.belongsTo(models.League);
  };
  return Bet;
};
