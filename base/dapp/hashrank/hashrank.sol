pragma solidity ^0.4.0;

// This allows stakeholders to approve an IPFS hash, and can return the
// weighted sum of ether that approved it. Used for rank & anti-phishing.

contract HashRank {
  // Who approved this hash
  mapping (uint256 => address[]) approved;
  
  struct Entry {
      bytes hash;
      bytes name;
      bytes desc;
  }
  
  Entry[] entries;
  
  // Registers a hash
  function register(bytes hash, bytes name, bytes desc) public {
      entries.push(Entry(hash,name,desc));
  }
  
  // Approves an entry
  function approve(uint256 index) public {
    approved[index].push(msg.sender);
  }
  
  // Computes the rank (eth-weighted sum of approvals) of the entry
  function rankOf(uint256 index) public constant returns (uint256) {
    uint256 rank = 0;
    
    uint256 len = approved[index].length;
    for (uint256 i = 0; i < len; ++i) { 
      address voter = approved[index][i];
        
      // Checks if voter already voted
      // FIXME: this would be less stupid with an in-memory map, but how?
      bool voted = false;
      for (uint256 j = 0; j < i; ++j) {
        voted = voted || approved[index][j] == voter;
      }
      
      if (!voted) {
        rank += voter.balance;
      }
    }
    return rank;
  }
  
  // Returns the number of entries
  function entriesCount() public constant returns (uint256) {
      return entries.length;
  }
  
  // Returns the hash of an entry
  function entryHash(uint256 index) public constant returns (bytes) {
      return entries[index].hash;
  }
  
  // Returns the name of an entry
  function entryName(uint256 index) public constant returns (bytes) {
      return entries[index].name;
  }
  
  // Returns the desc of an entry
  function entryDesc(uint256 index) public constant returns (bytes) {
      return entries[index].desc;
  }
}

// 0.4.18+commit.9cf6e910.Emscripten.clang
// 6060604052341561000f57600080fd5b6108068061001e6000396000f3006060604052600436106100825763ffffffff7c01000000000000000000000000000000000000000000000000000000006000350416635612acce811461008757806358c9c0811461011457806382f68dc41461012a5780639878185e14610152578063ab4ccf0114610168578063b759f9541461017b578063d438035314610193575b600080fd5b341561009257600080fd5b61009d600435610268565b60405160208082528190810183818151815260200191508051906020019080838360005b838110156100d95780820151838201526020016100c1565b50505050905090810190601f1680156101065780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b341561011f57600080fd5b61009d60043561032f565b341561013557600080fd5b6101406004356103bf565b60405190815260200160405180910390f35b341561015d57600080fd5b61009d6004356104cb565b341561017357600080fd5b61014061055b565b341561018657600080fd5b610191600435610562565b005b341561019e57600080fd5b61019160046024813581810190830135806020601f8201819004810201604051908101604052818152929190602084018383808284378201915050505050509190803590602001908201803590602001908080601f01602080910402602001604051908101604052818152929190602084018383808284378201915050505050509190803590602001908201803590602001908080601f0160208091040260200160405190810160405281815292919060208401838380828437509496506105c295505050505050565b610270610655565b600180548390811061027e57fe5b90600052602060002090600302016002018054600181600116156101000203166002900480601f0160208091040260200160405190810160405280929190818152602001828054600181600116156101000203166002900480156103235780601f106102f857610100808354040283529160200191610323565b820191906000526020600020905b81548152906001019060200180831161030657829003601f168201915b50505050509050919050565b610337610655565b600180548390811061034557fe5b90600052602060002090600302016000018054600181600116156101000203166002900480601f0160208091040260200160405190810160405280929190818152602001828054600181600116156101000203166002900480156103235780601f106102f857610100808354040283529160200191610323565b6000818152602081905260408120548190818080805b848410156104bf5760008881526020819052604090208054859081106103f757fe5b600091825260208220015473ffffffffffffffffffffffffffffffffffffffff16935091508190505b8381101561049057818061048657506000888152602081905260409020805473ffffffffffffffffffffffffffffffffffffffff851691908390811061046257fe5b60009182526020909120015473ffffffffffffffffffffffffffffffffffffffff16145b9150600101610420565b8115156104b4578273ffffffffffffffffffffffffffffffffffffffff1631860195505b8360010193506103d5565b50939695505050505050565b6104d3610655565b60018054839081106104e157fe5b90600052602060002090600302016001018054600181600116156101000203166002900480601f0160208091040260200160405190810160405280929190818152602001828054600181600116156101000203166002900480156103235780601f106102f857610100808354040283529160200191610323565b6001545b90565b60008181526020819052604090208054600181016105808382610667565b506000918252602090912001805473ffffffffffffffffffffffffffffffffffffffff19163373ffffffffffffffffffffffffffffffffffffffff1617905550565b600180548082016105d38382610690565b91600052602060002090600302016000606060405190810160409081528782526020820187905281018590529190508151819080516106169291602001906106bc565b506020820151816001019080516106319291602001906106bc565b5060408201518160020190805161064c9291602001906106bc565b50505050505050565b60206040519081016040526000815290565b81548183558181151161068b5760008381526020902061068b91810190830161073a565b505050565b81548183558181151161068b5760030281600302836000526020600020918201910161068b9190610754565b828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f106106fd57805160ff191683800117855561072a565b8280016001018555821561072a579182015b8281111561072a57825182559160200191906001019061070f565b5061073692915061073a565b5090565b61055f91905b808211156107365760008155600101610740565b61055f91905b8082111561073657600061076e8282610793565b61077c600183016000610793565b61078a600283016000610793565b5060030161075a565b50805460018160011615610100020316600290046000825580601f106107b957506107d7565b601f0160209004906000526020600020908101906107d7919061073a565b505600a165627a7a72305820a2ec6fedbffaa2a4cac36a905ff9f9ffb1af8485c3a26d14c4dbd530b0a4bdf00029
// [{"constant":true,"inputs":[{"name":"index","type":"uint256"}],"name":"entryDesc","outputs":[{"name":"","type":"bytes"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"index","type":"uint256"}],"name":"entryHash","outputs":[{"name":"","type":"bytes"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"index","type":"uint256"}],"name":"rankOf","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"index","type":"uint256"}],"name":"entryName","outputs":[{"name":"","type":"bytes"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"entriesCount","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"index","type":"uint256"}],"name":"approve","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"hash","type":"bytes"},{"name":"name","type":"bytes"},{"name":"desc","type":"bytes"}],"name":"register","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"}]
