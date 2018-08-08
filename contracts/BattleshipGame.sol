pragma solidity ^0.4.23;

contract BattleshipGame {

  enum GameState {InPlay, PlacingShips, GameEnded}

  uint8 constant BOARDSIZE = 10;

 struct ship {
      string shipName;
      uint8 shipLength;
      uint8 shipCode;
      uint8 shipStatus;
      uint8 shipDamage;
  }

  struct playerState {
      address playerAddr;
      string playerName;
      uint[BOARDSIZE][BOARDSIZE] boardMatrix;
      ship[] ships;
  }

  playerState player1;
  playerState player2;

  struct Game {
    playerState player1;
    playerState player2;
    GameState gameState;
  }

  ship frigate;
  ship submarine;
  ship destroyer;

  GameState gameState;

  playerState currentPlayer;

  string shotResult;

  uint8 constant MISS = 8;
  uint8 constant HIT = 9;

  uint8 constant SHIP_FREE = 0;
  uint8 constant SHIP_PLACED = 1;
  uint8 constant SHIP_SUNK = 2;

  uint8 constant HORIZONTAL = 0;
  uint8 constant VERTICAL = 1;

  uint8 constant NUM_OF_SHIPS = 3;

  constructor() public {
    gameState = GameState.PlacingShips;

    frigate.shipName = "FRIGATE";
    frigate.shipLength = 1;
    frigate.shipCode = frigate.shipLength;
    frigate.shipStatus = SHIP_FREE;
    submarine.shipName = "SUBMARINE";
    submarine.shipLength = 2;
    submarine.shipCode = submarine.shipLength;
    submarine.shipStatus = SHIP_FREE;
    destroyer.shipName = "DESTROYER";
    destroyer.shipLength = 3;
    destroyer.shipCode = destroyer.shipLength;
    destroyer.shipStatus = SHIP_FREE;

    player1.ships.push(frigate);
    player1.ships.push(submarine);
    player1.ships.push(destroyer);
    player2.ships.push(frigate);
    player2.ships.push(submarine);
    player2.ships.push(destroyer);
  }

  event LogShotResult(string, string);
  event LogPlaceLegality(string, string);
  event LogShipStartStop(uint,uint);
  event LogAllShipsPlaced(string);
  event LogShipPlaced(string,uint,uint,uint);
  event LogCurrentShip(string,string,uint);
  event LogShipSunk(string,string,string);
  event LogGameWon(string,string);
  event LogAllShipsSunk(string,string);
  event LogCheckShipStatus(string,string,uint8);


  modifier isGameInPlay {
    require(gameState == GameState.InPlay);
    _;
  }

 modifier hasGameEnded {
    require(gameState == GameState.GameEnded);
    _;
  }

  modifier playersRegistered {
      require(gameState == GameState.PlacingShips);
      _;
  }

  function returnPlayers() playersRegistered constant public returns (string, string) {
    return (player1.playerName, player2.playerName);
  }

  function registerPlayer(string playerName) public returns (address) {

    bytes memory tempEmptyStringTest = bytes(player1.playerName);

    if (tempEmptyStringTest.length == 0) {
      player1.playerAddr = msg.sender;
      player1.playerName = playerName;
      currentPlayer = player1;
    } else {
      player2.playerAddr = msg.sender;
      player2.playerName = playerName;
      gameState = GameState.PlacingShips;
    }
    return (msg.sender);
  }

  function placeShip(uint8 x, uint8 y, string shipType, string playerName, uint8 direction) public playersRegistered {

      ship currentShip;

      //player1.playerName = "Chris";

      playerState placingPlayer;

      if (compareStrings(playerName, player1.playerName)) {
          placingPlayer = player1;
      } else {
          placingPlayer = player2;
      }

      if (compareStrings(shipType, frigate.shipName)) {
          currentShip = placingPlayer.ships[0];
      } else if (compareStrings(shipType, submarine.shipName)) {
          currentShip = placingPlayer.ships[1];
        } else if (compareStrings(shipType, destroyer.shipName)) {
              currentShip = placingPlayer.ships[2];
          }
      emit LogCurrentShip("Current ship is",currentShip.shipName, currentShip.shipCode);

      uint startSquareX = x;
      uint endSquareX = x+currentShip.shipLength;
      uint startSquareY = y;
      uint endSquareY = y+currentShip.shipLength;

      require(x >= 0 && y >= 0);
      require(endSquareX < BOARDSIZE && endSquareY < BOARDSIZE);
      require(currentShip.shipStatus == SHIP_FREE);



            if (direction == HORIZONTAL) {
              for (uint i=startSquareX; i<endSquareX; i++) {
                require(currentPlayer.boardMatrix[i][y] == 0);
                placingPlayer.boardMatrix[i][y] = currentShip.shipCode;
                currentShip.shipStatus = SHIP_PLACED;
                emit LogShipPlaced("Ship placed at location",i,y,currentShip.shipCode);
              }
            } else {
              for (i=startSquareY; i<endSquareY; i++) {
                require(currentPlayer.boardMatrix[x][i] == 0);
                placingPlayer.boardMatrix[x][i] = currentShip.shipCode;
                currentShip.shipStatus = SHIP_PLACED;
              }
            }


      bool allShipsPlaced = true;
      for (i=0; i<player1.ships.length; i++) {
          if (player1.ships[i].shipStatus == SHIP_FREE) {
            allShipsPlaced = false;
          }
      }
      for (i=0; i<player2.ships.length; i++) {
        if (player2.ships[i].shipStatus == SHIP_FREE) {
          allShipsPlaced = false;
        }
      }

      if (allShipsPlaced == true) {
          emit LogAllShipsPlaced("All Ships Placed");
          gameState = GameState.InPlay;
      }
  }

  function switchCurrentPlayer() internal {
      if (compareStrings(currentPlayer.playerName, player1.playerName)) {
          currentPlayer = player2;
      } else {
          currentPlayer = player1;
      }
  }

  function checkIfWon(string playerName_) returns (bool) {

      bool allShipsSunk = true;

      if (compareStrings(playerName_, player1.playerName)) {
          for (uint i=0; i<NUM_OF_SHIPS; i++) {
            emit LogCheckShipStatus(playerName_,player2.ships[i].shipName,player2.ships[i].shipStatus);
            if (player2.ships[i].shipStatus != SHIP_SUNK) {
              allShipsSunk = false;
            }
           }
      }

      if (compareStrings(playerName_, player2.playerName)) {
          for (i=0; i<NUM_OF_SHIPS; i++) {
            emit LogCheckShipStatus(playerName_,player1.ships[i].shipName,player1.ships[i].shipStatus);
            if (player1.ships[i].shipStatus != SHIP_SUNK) {
              allShipsSunk = false;
            }
           }
      }

      if (allShipsSunk == true) {
          emit LogAllShipsSunk("All ships sunk for", playerName_);
      }

      return allShipsSunk;
  }

  function fireShot(uint8 x, uint8 y) isGameInPlay public returns (string) {

      if (compareStrings(currentPlayer.playerName, player1.playerName)) {
          if (player2.boardMatrix[x][y] >= 1 && player2.boardMatrix[x][y] <= 5) {
              shotResult = "HIT";
              uint player2ShipType = player2.boardMatrix[x][y];

              player2.boardMatrix[x][y] = HIT;
              player2.ships[player2ShipType-1].shipDamage++;
              if (player2.ships[player2ShipType-1].shipDamage == player2ShipType) {
                  player2.ships[player2ShipType-1].shipStatus = SHIP_SUNK;
                  emit LogShipSunk(player2.playerName, player2.ships[player2ShipType-1].shipName, "SUNK");
              }

              emit LogShotResult(shotResult,currentPlayer.playerName);
              if (checkIfWon(currentPlayer.playerName)) {
                  gameState = GameState.GameEnded;
                  emit LogGameWon("Game Won!",currentPlayer.playerName);
              }
              switchCurrentPlayer();
              return (shotResult);
          } else {
              shotResult = "MISS";
              player2.boardMatrix[x][y] = MISS;
              emit LogShotResult(shotResult,currentPlayer.playerName);

              switchCurrentPlayer();
              return (shotResult);
          }
      } else {
          if (player1.boardMatrix[x][y] >= 1 && player1.boardMatrix[x][y] <= 5) {
              shotResult = "HIT";
              uint player1ShipType = player1.boardMatrix[x][y];

              player1.boardMatrix[x][y] = HIT;
              player1.ships[player1ShipType-1].shipDamage++;
              if (player1.ships[player1ShipType-1].shipDamage == player1ShipType) {
                  player1.ships[player1ShipType-1].shipStatus = SHIP_SUNK;
                  emit LogShipSunk(player1.playerName, player1.ships[player1ShipType-1].shipName, "SUNK");
              }
              emit LogShotResult(shotResult,currentPlayer.playerName);
              if (checkIfWon(currentPlayer.playerName)) {
                  gameState = GameState.GameEnded;
                  emit LogGameWon("Game Won!", currentPlayer.playerName);
              }
              switchCurrentPlayer();
              return shotResult;
          } else {
              shotResult = 'MISS';
              player1.boardMatrix[x][y] = MISS;
              emit LogShotResult(shotResult,currentPlayer.playerName);
              switchCurrentPlayer();
              return shotResult;
          }
      }
  }

  function clearGame() public {
     for (uint8 x=0; x<BOARDSIZE; y++) {
       for (uint8 y=0; y<BOARDSIZE; y++) {
         player1.boardMatrix[x][y] = 0;
         player2.boardMatrix[x][y] = 0;
       }
     }
    for (uint8 i=0; i<NUM_OF_SHIPS; i++) {
       player1.ships[i].shipStatus = SHIP_FREE;
       player1.ships[i].shipDamage = 0;
       player2.ships[i].shipStatus = SHIP_FREE;
       player2.ships[i].shipDamage = 0;
     }

     player1.playerName = '';
     player2.playerName = '';

    currentPlayer = player1;

  }

  function returnBoard(string playerName_) public constant returns (uint) {
      for (uint8 i=0; i<BOARDSIZE; i++) {
          if ( compareStrings(playerName_,player1.playerName)) {
              return player1.boardMatrix[9][9];
          }
      }
  }

  function compareStrings (string a, string b) view returns (bool) {
       return keccak256(a) == keccak256(b);
  }


}
