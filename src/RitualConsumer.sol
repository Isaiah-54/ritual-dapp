// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title Minimal Ritual async consumer
/// @notice Check 4 (callback auth) + Check 5 (empty/late result handling).
///         Pattern mirrors official SovereignAgentConsumer.
contract RitualConsumer {
    address constant ASYNC_DELIVERY = 0x5A16214fF555848411544b005f7Ac063742f39F6;

    bytes32 public lastJobId;
    bytes public lastResult;
    bool public hasResult;
    bool public wasEmpty;

    mapping(bytes32 => uint256) public pendingSinceBlock;
    uint256 public constant PENDING_TTL = 500; // blocks (~175s on Ritual)

    event ResultDelivered(bytes32 indexed jobId, bytes result, bool empty);
    event PendingExpired(bytes32 indexed jobId);

    /// @dev First line MUST require msg.sender == AsyncDelivery (Check 4).
    function onResult(bytes32 jobId, bytes calldata result) external {
        require(msg.sender == ASYNC_DELIVERY, "unauthorized callback sender");

        if (hasResult && lastJobId == jobId) {
            return;
        }

        require(pendingSinceBlock[jobId] != 0, "unknown job");

        lastJobId = jobId;
        lastResult = result;
        hasResult = true;
        wasEmpty = result.length == 0;
        delete pendingSinceBlock[jobId];

        emit ResultDelivered(jobId, result, wasEmpty);
    }

    function markPending(bytes32 jobId) external {
        pendingSinceBlock[jobId] = block.number;
    }

    function clearExpired(bytes32 jobId) external {
        uint256 since = pendingSinceBlock[jobId];
        require(since != 0, "not pending");
        require(block.number > since + PENDING_TTL, "still within TTL");
        delete pendingSinceBlock[jobId];
        emit PendingExpired(jobId);
    }

    function isPending(bytes32 jobId) external view returns (bool) {
        uint256 since = pendingSinceBlock[jobId];
        if (since == 0) return false;
        return block.number <= since + PENDING_TTL;
    }
}
