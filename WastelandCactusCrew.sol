// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

abstract contract CrewCard {
  function ownerOf(uint256 tokenId) public virtual view returns (address);
}

contract WastelandCactusCrew is ERC721, ERC721Enumerable, Ownable {

    CrewCard private cc = CrewCard(0x25A3273f1b1F468845D08623FBe4b0885Fc12cf0);
    string public baseURL;
    string public provenance;
    bool public f1 = false;
    bool public f2 = false;
    bool public f3 = false;
    bool public f4 = false;
    uint public price = 60000000000000000; // 0.06 ETH 
    uint public maxSupply = 8500;
    uint public maxPerTransaction = 4;
    mapping(address => uint) m3;
    mapping(uint => uint) m4;
    mapping(address => uint) m1;
    mapping(address => uint) m2;
    uint public ltc = 0;
    uint public ef = 0;
    uint public totalCrewClaimed = 0;
    address private rl = 0x6e6093a650dcABc96eE4C40C02ba5788B1267160;

    constructor() ERC721("WastelandCactusCrew", "WLCC") {
    }

    function setltc(uint n) public onlyOwner {
        ltc = n;
    }

    function ff1() public onlyOwner {
        f1 = !f1;
    }

    function ff2() public onlyOwner {
        f2 = !f2;
    }

    function ff3() public onlyOwner {
        f3 = !f3;
    }

    function ff4() public onlyOwner {
        f4 = !f4;
    }

    function setbaseuri(string memory uri) public onlyOwner {
        baseURL = uri;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURL;
    }

    function setprovhash(string memory provenanceHash) public onlyOwner {
        provenance = provenanceHash;
    }
    
    function addsinglewhitelist(address[] memory addresses) public onlyOwner {
        for(uint i = 0; i < addresses.length; i++) {
            m3[addresses[i]] = 1;
        }
    }

    function adddoublewhitelist(address[] memory addresses) public onlyOwner {
        for(uint i = 0; i < addresses.length; i++) {
            m3[addresses[i]] = 2;
        }
    }

    function checkm1(address a) public view returns (uint) {
        return m1[a];
    }

    function checkm2(address a) public view returns (uint) {
        return m2[a];
    }

    function checkm3(address a) public view returns (uint) {
        return m3[a];
    }

    function checkm4(uint n) public view returns (uint) {
        return m4[n];
    }
    
    function airdrop(address to) public onlyOwner {
        _safeMint(to, totalSupply());
    }

    function devreserve(uint n) public onlyOwner {
        for(uint i = 0; i < n; i++) {
            _mint(msg.sender, totalSupply());
        }
    }

    function executef1b(uint n) public payable {
        require(f1);
        uint t = m3[msg.sender];
        require(t > 0 && n > 0 && n <= t);
        require(msg.value >= price * n);

        for(uint i = 0; i < n; i++) {
            _mint(msg.sender, totalSupply());
        }

        m3[msg.sender] = (t - n);
    }

    function executef1a(uint t, uint n) public payable {
        require(f1);
        require(cc.ownerOf(t) == msg.sender);
        uint b = m4[t];
        require(b > 0 && n > 0 && n <= b);
        require(msg.value >= price * n);
    
        for(uint i = 0; i < n; i++) {
            _mint(msg.sender, totalSupply());
        } 
        
        m4[t] = (b - n);
    }

    function executef2(uint n) public { // set ltc before f2
        require(f2 && n > 0 && n <= 4);
        if(ef >= ltc) {
            m2[msg.sender] = n;
        } else {
            m1[msg.sender] = n;
            ef = ef + n;
        }
    }

    function executef3() public payable {
        require(f3);
        uint b = m1[msg.sender];
        require(totalSupply() + b <= maxSupply);
        require(msg.value >= price * b);

        for(uint i = 0; i < b; i++) {
            _mint(msg.sender, totalSupply());
        }
    }

    function executef4(uint n) public payable {
        require(f4);
        require(n <= maxPerTransaction);
        require(totalSupply() + n <= maxSupply);
        require(msg.value >= price * n);

        for(uint i = 0; i < n; i++) {
            _mint(msg.sender, totalSupply());
        }
    }   

    function executef5() public payable {
        require(f3);
        uint b = m2[msg.sender];
        require(totalSupply() + b <= maxSupply);
        require(msg.value >= price * b);

        for(uint i = 0; i < b; i++) {
            _mint(msg.sender, totalSupply());
        }
    }

    function withdraw() public onlyOwner {
        uint b = address(this).balance;        
        payable(rl).transfer(b / 4);
        payable(msg.sender).transfer(b * 3 / 4);
    }

    // The following functions are overrides required by Solidity.
    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}