# wallet_product

Layer 3 wallet product. It owns the personal wallet domain and its transaction ledger as one cohesive product.

## Responsibility

- Wallet setup, balances, wallet details and wallet queries.
- Transaction ingestion, history, details, notes, receipts, filters and reports.
- Wallet-specific SMS adaptation, reconciliation, persistence and retries using the Layer 2 `sms_engine` capability.
- Product screens, state, domain rules and data access for those workflows.

Transactions are part of this product because a wallet owns the ledger associated with it. There is no separate transaction product.

## Layer boundary

The product depends on Layer 1 and reusable capabilities such as `sms_engine`. It does not depend on `workspace_product`, `identity_product` or the app. It exposes supported contracts and screens from `lib/wallet_product.dart`; the Layer 4 app registers routes and provides host/platform integrations.

## Use

```yaml
dependencies:
  wallet_product:
    git:
      url: https://github.com/mahafez-app/wallet_product.git
      ref: v2.1.0
```

Import `package:wallet_product/wallet_product.dart`. Do not import implementation files under `src` from another repository.
