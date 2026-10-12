# ritual-dapp

Public Ritual Chain starter: **ritual-dapp-skills** checkpoints, Foundry `via_ir`, AsyncDelivery-authenticated callbacks, and a path to **Price Pulse**.

Based on [Ritual Office Hours static checks](https://x.com/ritualfnd/status/2107548970373525760).

Official skills: https://github.com/ritual-foundation/ritual-dapp-skills

## Full agent build

```bash
git clone https://github.com/Isaiah-54/ritual-dapp.git
cd ritual-dapp
chmod +x scripts/*.sh
./scripts/setup-skills.sh
./scripts/check-progress.sh
```

Then open **[AGENT.md](AGENT.md)** and paste the agent prompt (wallet + idea).

## Already done

| Check / artifact | Status |
|------------------|--------|
| `via_ir = true` | `foundry.toml` |
| Callback auth (AsyncDelivery) | `src/RitualConsumer.sol` |
| Empty / late / idempotent tests | 6 unit tests |
| `progress.json` seeded | phases 0–2 complete |

```bash
forge install foundry-rs/forge-std
forge build && forge test -vv
```

## The 5 static checks

1. First `false` marker in `.ritual-build/progress.json`
2. Overview skill in `files_read`
3. `via_ir = true`
4. Callback requires AsyncDelivery
5. Tests cover empty/late path — see `docs/ritual-static-checks.md`

Happy building on Ritual ⛓
