# Ritual full agent build — start here

Wired for official **ritual-dapp-skills**.

## 1. Install skills (once)

```bash
mkdir -p .claude/skills
git clone --depth 1 https://github.com/ritual-foundation/ritual-dapp-skills.git .claude/skills/ritual-dapp-skills
```

Or: `./scripts/setup-skills.sh`

## 2. Prompt for your agent

```
Read the file .claude/skills/ritual-dapp-skills/skills/ritual/SKILL.md and follow its instructions.

This is an existing Ritual project (Foundry). Resume from .ritual-build/progress.json.
Do not restart from scratch unless I ask.

WALLET: 0xYOUR_FUNDED_WALLET_ADDRESS

Build me Price Pulse: on-chain HTTP price fetcher extending RitualConsumer
(keep AsyncDelivery auth, empty/late escape hatch). Integrate RitualWallet,
preflight hasPendingJobForSender, store lastPrice, Foundry mocks, deploy on chain 1979.
```

## 3. Current state

| Artifact | Status |
|----------|--------|
| via_ir | Done |
| AsyncDelivery callback auth | Done |
| Unit tests (empty/late/idempotent) | Done |
| progress.json | Resume from phase 3 |

## References

- Skills: https://github.com/ritual-foundation/ritual-dapp-skills
- Chain 1979 · RPC https://rpc.ritualfoundation.org
