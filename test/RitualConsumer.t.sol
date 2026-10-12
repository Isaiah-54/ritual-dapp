// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/RitualConsumer.sol";

contract RitualConsumerTest is Test {
    RitualConsumer internal consumer;
    address constant ASYNC_DELIVERY = 0x5A16214fF555848411544b005f7Ac063742f39F6;

    function setUp() public {
        consumer = new RitualConsumer();
    }

    function test_callbackRevertsFromUnauthorizedSender() public {
        bytes32 jobId = keccak256("job-1");
        bytes memory result = abi.encode("hello");

        vm.prank(address(0xdead));
        vm.expectRevert("unauthorized callback sender");
        consumer.onResult(jobId, result);
    }

    function test_callbackSucceedsFromAsyncDelivery() public {
        bytes32 jobId = keccak256("job-1");
        bytes memory result = abi.encode("hello");

        consumer.markPending(jobId);

        vm.prank(ASYNC_DELIVERY);
        consumer.onResult(jobId, result);

        assertEq(consumer.lastJobId(), jobId);
        assertEq(consumer.lastResult(), result);
        assertTrue(consumer.hasResult());
        assertFalse(consumer.wasEmpty());
    }

    function test_emptyResultDoesNotHang() public {
        bytes32 jobId = keccak256("empty-job");
        bytes memory empty;

        consumer.markPending(jobId);

        vm.prank(ASYNC_DELIVERY);
        consumer.onResult(jobId, empty);

        assertTrue(consumer.hasResult());
        assertTrue(consumer.wasEmpty());
        assertEq(consumer.lastResult().length, 0);
        assertFalse(consumer.isPending(jobId));
    }

    function test_lateCallbackAfterTTL_canBeCleared() public {
        bytes32 jobId = keccak256("late-job");
        consumer.markPending(jobId);
        assertTrue(consumer.isPending(jobId));

        vm.roll(block.number + 501);

        consumer.clearExpired(jobId);
        assertFalse(consumer.isPending(jobId));
    }

    function test_clearExpiredRevertsWhileWithinTTL() public {
        bytes32 jobId = keccak256("still-pending");
        consumer.markPending(jobId);

        vm.expectRevert("still within TTL");
        consumer.clearExpired(jobId);
    }

    function test_idempotentCallback() public {
        bytes32 jobId = keccak256("idempotent");
        bytes memory result = abi.encode("once");

        consumer.markPending(jobId);

        vm.prank(ASYNC_DELIVERY);
        consumer.onResult(jobId, result);

        vm.prank(ASYNC_DELIVERY);
        consumer.onResult(jobId, abi.encode("twice"));

        assertEq(consumer.lastResult(), result);
    }
}
