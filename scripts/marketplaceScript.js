const main = async () => {
  const nftMarketplaceContractFactory = await hre.ethers.getContractFactory(
    'NFTMarketplace'
  );
  const nftMarketplaceContract = await nftMarketplaceContractFactory.deploy();
  await nftMarketplaceContract.deployed();
  console.log('Contract deployed to:', nftMarketplaceContract.address);

  txn = await nftMarketplaceContract.addArtist(
    '0x5FbDB2315678afecb367f032d93F642f64180aa3',
    'Pratik',
    'https://ipfs.io/ipfs/QmccvQQrctwZyic85Rk1JE43u2oKMCHTNwm6sr5vgXaLes?filename=prateek_kuhaad.jpg',
    'music'
  );
  await txn.wait();
  console.log('Artist added ---', txn);

  txn = await nftMarketplaceContract.getArtistInfo(
    '0x5FbDB2315678afecb367f032d93F642f64180aa3'
  );
  console.log('Artist Info --->', txn);

  const FandomNFT = await hre.ethers.getContractFactory('FanClubNFT');
  const nftContract = await FandomNFT.deploy(
    'Fandom',
    'FAN',
    nftMarketplaceContract.address
  );
  await nftContract.deployed();
  console.log('NFT Contract deployed!!');

  txn = await nftContract.launchNFT(
    10,
    'https://ipfs.io/ipfs/QmYfmHvCZsxgzPWMUynMDNGYpAu4VYCU2R6mMg37hX2E25?filename=fire.json'
  );
  await txn.wait();
  console.log('NFT Launched!!');

  txn = await nftMarketplaceContract.listNFT(
    nftContract.address,
    '0x5FbDB2315678afecb367f032d93F642f64180aa3',
    1,
    10,
    hre.ethers.utils.parseEther('10'),
    'Fandom',
    'Fan token',
    'https://ipfs.io/ipfs/QmccvQQrctwZyic85Rk1JE43u2oKMCHTNwm6sr5vgXaLes?filename=prateek_kuhaad.jpg',
    'premium'
  );
  await txn.wait();
  console.log('NFT listed');

  txn = await nftMarketplaceContract.buyNFTs(nftContract.address, 1, {
    value: hre.ethers.utils.parseEther('10'),
  });
  await txn.wait();
  console.log('Bought the NFTs');

  let nfts = await nftMarketplaceContract.getNFTsOfArtist(
    '0x5FbDB2315678afecb367f032d93F642f64180aa3'
  );
  console.log('NFTs ---->', nfts);
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
