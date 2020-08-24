"use strict";

module.exports = {
  up: (queryInterface, Sequelize) => {
    return queryInterface.bulkInsert(
      "Games",
      [
        {
          gameId: 14949,
          season: 2020,
          status: "Scheduled",
          dateTime: "2020-03-21T20:00:00",
          awayTeam: "NO",
          homeTeam: "MEM",
          createdAt: new Date(),
          updatedAt: new Date()
        }
      ],
      {}
    );
  },

  down: (queryInterface, Sequelize) => {
    return queryInterface.bulkDelete("Games", null, {});
  }
};
