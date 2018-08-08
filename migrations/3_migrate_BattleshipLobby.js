var BattleshipLobby = artifacts.require("BattleshipLobby");

module.exports = function(deployer) {
  deployer.deploy(BattleshipLobby);
}
