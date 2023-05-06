require("dotenv").config();

require("@nomiclabs/hardhat-etherscan");
require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-ethers");
require("solidity-coverage");
require("hardhat-deploy");
require("hardhat-deploy-ethers");
require("hardhat-contract-sizer");
require("@nomiclabs/hardhat-solhint");
require("hardhat-tracer");
require("@atixlabs/hardhat-time-n-mine");
require("hardhat-local-networks-config-plugin");
require("@nomiclabs/hardhat-web3");

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

const COINMARKETCAP_API_KEY = process.env.COINMARKETCAP_API_KEY || "";
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY || "";
const TENDERLY_PROJECT = process.env.TENDERLY_PROJECT || "";
const TENDERLY_USERNAME = process.env.TENDERLY_USERNAME || "";
const HARDHAT_DEPENDENCY_COMPILER_KEEP = (process.env.HARDHAT_DEPENDENCY_COMPILER_KEEP === "true");

/**
* @type import('hardhat/config').HardhatUserConfig
*/
module.exports = {
solidity: {
    compilers: [
        {
            version: "0.8.7",
            settings: {
                optimizer: {
                    enabled: true,
                    runs: 200
                }
            }
        },
        {
            version: "0.5.16",
            settings: {
                optimizer: {
                    enabled: true,
                    runs: 200
                }
            }
        }
    ]
},
networks: {
hardhat: {}
},
spdxLicenseIdentifier: {
overwrite: false,
runOnCompile: false
},
dependencyCompiler: {
paths: ["@openzeppelin/contracts/token/ERC20/IERC20.sol"],
keep: HARDHAT_DEPENDENCY_COMPILER_KEEP
},
docgen: {
path: "./docgen",
clear: true,
runOnCompile: true
},
localNetworksConfig: `${process.cwd()}/networks.js`,
gasReporter: {
coinmarketcap: COINMARKETCAP_API_KEY,
enabled: false,
currency: "USD",
showMethodSig: false,
showTimeSpent: true
},
etherscan: {
apiKey: "2CXTRDK2VAKHFF6B6XX1WCF4Z7SNEWG3UT",
customChains: [
{
network: "arbitrum_goerli",
chainId: 421613,
urls: {
apiURL: "https://api-goerli.arbiscan.io/api"
}
}
],
},
typechain: {
outDir: "typechain",
target: "ethers-v5"
},
contractSizer: {
alphaSort: true,
runOnCompile: false,
disambiguatePaths: false
},
tenderly: {
project: TENDERLY_PROJECT,
username: TENDERLY_USERNAME
}
};