require('dotenv').config();
require("@nomiclabs/hardhat-ethers");
/** @type import('hardhat/config').HardhatUserConfig */


module.exports = {
  solidity: "0.8.17",
  defaultNetwork: "ropsten",
  networks: {
    mainnet: {
      url: process.env.MAINNET_API_URL,
      accounts: [process.env.PRIVATE_KEY]
    },
    ropsten: {
      url: process.env.ROPSTEN_API_URL,
      accounts: [process.env.PRIVATE_KEY]
    }
  }
};
