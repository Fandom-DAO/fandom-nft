require('@nomiclabs/hardhat-waffle');
const fs = require('fs');
const privateKey =
  fs.readFileSync('.secret').toString().trim() || '01234567890123456789';
const infuraId = fs.readFileSync('.infuraid').toString().trim() || '';
// const infuraId = process.env.infuraId;
// const privateKey = process.env.secret;

module.exports = {
  defaultNetwork: 'hardhat',
  networks: {
    hardhat: {
      chainId: 1337,
    },
    rinkeby: {
      url: `https://rinkeby.infura.io/v3/${infuraId}`,
      accounts: [privateKey],
    },
  },
  solidity: {
    version: '0.8.4',
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
};
