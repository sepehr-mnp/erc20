solc = require("solc");
fs = require("fs");
Web3 = require("web3");

const ganache = require("ganache-cli");

web3 = new Web3(new Web3.providers.HttpProvider("https://rpc.ankr.com/eth_goerli"));// deploy on goerli testnet
  
file = fs.readFileSync("contract/ERC20.sol").toString();

var input = {
	language: "Solidity",
	sources: {
		"ERC20.sol": {
			content: file,
		},
	},

	settings: {
		outputSelection: {
			"*": {
				"*": ["*"],
			},
		},
	},
};

var output = JSON.parse(solc.compile(JSON.stringify(input)));
console.log("Result : ", output);

ABI = output.contracts["ERC20.sol"]["ERC20"].abi;
bytecode = output.contracts["ERC20.sol"]["ERC20"].evm.bytecode.object;

web3.setProvider(web3.currentProvider);
contract = new web3.eth.Contract(ABI);
const deploy = async () => {
	let wallet = web3.eth.accounts.wallet.add(web3.eth.accounts.privateKeyToAccount(
  // put your private key as string in here
  ));
    console.log(wallet);
	console.log("abi:",ABI);
	console.log('Attempting to deploy from account', wallet["address"]);
	contract
	.deploy({ data: bytecode , arguments: [100000000000000000000000]// we give this to constructor to
          })
	.send({from: wallet["address"], gas: 10000000})
	.on("receipt", (receipt) => {
    console.log("Contract Address:", receipt.contractAddress);
	});
  };
deploy();
