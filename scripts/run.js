const main = async () => {
  const NFTMarket = await hre.ethers.getContractFactory('NFTMarketplace');
  const nftMarket = await NFTMarket.deploy();

  await nftMarket.deployed();

  console.log('nftMarket deployed to:', nftMarket.address);

  const fandomNFT = await hre.ethers.getContractFactory('FanClubNFT');
  const nftContract = await fandomNFT.deploy("Fando","FAN",nftMarket.address);

  await nftContract.deployed();

  console.log('NFT Contract deployed to:', nftContract.address);

  txn = await nftContract.launchNFT(10, "https://ipfs.io/ipfs/QmYfmHvCZsxgzPWMUynMDNGYpAu4VYCU2R6mMg37hX2E25?filename=fire.json" );
  await txn.wait();
  console.log("tx", txn)
  console.log('NFTs launched ---', txn.data);

  txn = await nftContract.uri(1);
  console.log('URI --->', txn);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
