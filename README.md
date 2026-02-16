# Ticket Booking Mobile App

## Documentation

- Technical assignment write-up: [docs/technical-assignment.md](docs/technical-assignment.md)
- Latest tagged source snapshot: [v1.0.9](https://github.com/i-maple/bus_ticketing_mobile/tree/v1.0.9)

## Quick Notes

- State management: Riverpod
- Data layer: GraphQL client with local/mock GraphQL link
- DI: GetIt
- Code generation: freezed/json_serializable/riverpod_generator/mockito

## Khalti Test Setup

Khalti ePayment uses app deep links with `uni_links`.

Hardcoded URLs in app config:

- `khaltiReturnUrl`: `bus-ticketing://payment/khalti-return`
- `khaltiWebsiteUrl`: `bus-ticketing://payment/khalti-home`

Only secret key is required via env:

```bash
flutter run \
	--dart-define=KHALTI_SECRET_KEY=your_test_secret_key
```

Notes:

- `continue` in seat selection now initiates Khalti checkout.
- Callback is handled through deep links (`uni_links`) and always performs `pidx` lookup before final booking.
- Booking payment states are persisted as `pending`, `booked`, `cancelled`.
