const main = async () => {
  const nftMarketplaceContractFactory = await hre.ethers.getContractFactory(
    'NFTMarketplace'
  );
  const nftMarketplaceContract = await nftMarketplaceContractFactory.deploy();
  await nftMarketplaceContract.deployed();
  console.log('Contract deployed to:', nftMarketplaceContract.address);

  txn = await nftMarketplaceContract.addArtist("0x5FbDB2315678afecb367f032d93F642f64180aa3", "Pratik", "https://ipfs.io/ipfs/QmccvQQrctwZyic85Rk1JE43u2oKMCHTNwm6sr5vgXaLes?filename=prateek_kuhaad.jpg", "music");
  await txn.wait();
  console.log("Artist added ---", txn);
  

  txn = await nftMarketplaceContract.getArtistInfo("0x5FbDB2315678afecb367f032d93F642f64180aa3");
  console.log("Artist Info --->" , txn);
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
