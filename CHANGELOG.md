# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

# [0.5.0] Sprint 5 (2019-12-16)

In this sprint, we focused on adding most of the functionality needed for a minimum viable product. These features include all of the functionality with the users joining and getting invited to leagues, making bet for games within those leagues and seeing all available leagues and games. Alongside that, a lot of previously implemented features were polished and made ready for release, such as creating leagues and the user profile. 

### Added

- Create invitations for users to join leagues (#113)
- Integrate league invites page with profile page (#105)
- Add matches to leagues (#115)
- Improve association between games and leagues and between games and bets (#108)
- See worldwide leagues (#32)
- Betting backend connection (#107)
- Implement bet points calculation logic (#106)
- Add unit tests to backend (#110)

### Changed

- Improve profile page (#109)
- Fix user permissions (#114)

# [0.4.0] Sprint 4 (2019-12-02)

### Added

- Add a state management solution (#84)
- Add a creator to leagues and redefine associations (#101)
- Integrate game page with cards (#102)
- Implementations of checks for test code coverage (#90)
- App Telemetry is recorded and displayed (#97)
- Change IDs to UUID (#74)
- Set up automated server deployment (staging and production) (#82)
- Implementation of mutation tests (#88)
- Implementations of checks for test code coverage (#90)
- Integrate SportsData API (#103)
- Join league (#26)

### Changed

- Write more API documentation (#73)
- Fix native signup (#85)

# [0.3.0] Sprint 3 (2019-11-18)

### Added

- Add placeholder profile page (#81)
- See player profile (#35)
- See all members of a league (#30)
- See players on teams (#33)
- Create league (#25)
- Log in natively (#23)
- Sign up natively (#21)
- Register externally (#22)
- Route the Sportsdata API through our API (#63)
- Add validation to leagues (#78)
- Add linting stage to pipeline (#79)

### Changed

- Improve the match list user interface (#83)

# [0.2.0] Sprint 2 (2019-11-04)

### Added

- See match details (#64)
- Log in natively (#23) and externally (#24)
- Set up a linter on the frontend (#70)
- Refactor frontend to Model-View-Presenter (MVP) (#71)
- Dockerize the project (#66)
- Define league model (#65)
- Define bet model (#62)
- Create native user authentication (#61)
- Set up a CI/CD pipeline (#60)

### Changed

- Fix server usage on Windows (#67)

# [0.1.0] Sprint 1 (2019-10-21)

### Added

- Set up project frontend
- See all upcoming matches for the current week
- See all recent matches that happened in the past week
- Get team logos and full names
- Make a stateful match card widget
- Improve app page routing
- Set up project backend
- Set up the database connection in the backend
- Set up a linter (ESLint) on the backend
- Add a CONTRIBUTING.md file
