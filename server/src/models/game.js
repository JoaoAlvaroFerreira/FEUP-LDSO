export default (sequelize, DataTypes) => {
  const Game = sequelize.define(
    "Game",
    {
      GameID: {
        type: DataTypes.INTEGER,
        allowNull: { args: false, msg: "Please enter a game id" }
      },
      Season: DataTypes.INTEGER,
      Status: {
        type: DataTypes.STRING,
        allowNull: { args: false, msg: "Please enter a status" }
      },
      DateTime: {
        type: DataTypes.DATE,
        allowNull: { args: false, msg: "Please enter a date time" }
      },
      AwayTeam: {
        type: DataTypes.STRING,
        allowNull: { args: false, msg: "Please enter a away team" }
      },
      HomeTeam: {
        type: DataTypes.STRING,
        allowNull: { args: false, msg: "Please enter a home team" }
      },
      AwayTeamID: DataTypes.INTEGER,
      HomeTeamID: DataTypes.INTEGER,
      StadiumID: DataTypes.INTEGER,
      Stadium: DataTypes.STRING,
      AwayTeamScore: {
        type: DataTypes.INTEGER,
        defaultValue: 0
      },
      HomeTeamScore: {
        type: DataTypes.INTEGER,
        defaultValue: 0
      },
      IsClosed: DataTypes.BOOLEAN,
      GameEndDateTime: DataTypes.DATE
    },
    {}
  );
  Game.associate = function(models) {
    // One user has many bets
    Game.hasMany(models.Bet);
    // One game can be in many leagues
    Game.belongsToMany(models.League, {
      through: "GameLeagues"
    });
  };
  return Game;
};
