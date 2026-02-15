# Technical Assignment Documentation (Flutter Developer)

## Quick Navigation
- [Project Summary](#project-summary)
- [Latest Tag and Source Links](#latest-tag-and-source-links)
- [Requirement Coverage (Assignment -> Code)](#requirement-coverage-assignment---code)
- [Architecture and Scalability Notes](#architecture-and-scalability-notes)
- [UI/UX and Interaction Notes](#uiux-and-interaction-notes)
- [Testing and Quality Gates](#testing-and-quality-gates)
- [Deliverables and CI](#deliverables-and-ci)
- [Future Extensibility Plan](#future-extensibility-plan)
- [Known Gaps / Next Improvements](#known-gaps--next-improvements)

## Project Summary
This app is implemented with **Flutter + Riverpod + GraphQL (mock/local link) + Clean Architecture style layers + GetIt DI**.

Core flow implemented:
1. Splash/onboarding routing
2. Home search + ticket results
3. Ticket details
4. Seat selection with dynamic layout/state
5. Booking success

This document maps each assignment requirement to actual code paths.

## Latest Tag and Source Links
- Repository: [i-maple/bus_ticketing_mobile](https://github.com/i-maple/bus_ticketing_mobile)
- Latest semantic tag: [v1.0.6](https://github.com/i-maple/bus_ticketing_mobile/tree/v1.0.6)
- Latest release page (rolling): [releases/latest](https://github.com/i-maple/bus_ticketing_mobile/releases/latest)

Primary source anchors at latest tag:
- DI setup: [injector.dart @ v1.0.6](https://github.com/i-maple/bus_ticketing_mobile/blob/v1.0.6/lib/core/di/injector.dart)
- GraphQL client: [app_graphql_client.dart @ v1.0.6](https://github.com/i-maple/bus_ticketing_mobile/blob/v1.0.6/lib/core/graphql/app_graphql_client.dart)
- Mock GraphQL link: [mock_graphql_link.dart @ v1.0.6](https://github.com/i-maple/bus_ticketing_mobile/blob/v1.0.6/lib/core/graphql/mock_graphql_link.dart)
- Seat map renderer: [seat_map_view.dart @ v1.0.6](https://github.com/i-maple/bus_ticketing_mobile/blob/v1.0.6/lib/features/seat_selection/presentation/widgets/seat_map_view.dart)

## Requirement Coverage (Assignment -> Code)

### 1) Seat & Ticket Management
**Assignment asks:** seat planning from local JSON, pricing, booked/available state, GraphQL integration.

Implemented in:
- Local JSON assets:
  - [assets/mock/seat_plan.json](../assets/mock/seat_plan.json)
  - [assets/mock/ticket_options.json](../assets/mock/ticket_options.json)
  - [assets/mock/home_overview.json](../assets/mock/home_overview.json)
- GraphQL mock transport + operation handlers:
  - [lib/core/graphql/mock_graphql_link.dart](../lib/core/graphql/mock_graphql_link.dart)
- GraphQL client wiring:
  - [lib/core/graphql/app_graphql_client.dart](../lib/core/graphql/app_graphql_client.dart)
- Seat datasource/repository/usecase flow:
  - [lib/features/seat_selection/data/data_sources/local/seat_selection_local_data_source.dart](../lib/features/seat_selection/data/data_sources/local/seat_selection_local_data_source.dart)
  - [lib/features/seat_selection/data/repositories/seat_selection_repository_impl.dart](../lib/features/seat_selection/data/repositories/seat_selection_repository_impl.dart)
  - [lib/features/seat_selection/domain/usecases/get_seat_plan_usecase.dart](../lib/features/seat_selection/domain/usecases/get_seat_plan_usecase.dart)

Why this satisfies the requirement:
- Seat plan is queried with GraphQL operation `GetSeatPlan`.
- Seat state and pricing are part of seat payload (`seatNumber`, `state`, `price`).
- Booked seats are merged from persisted bookings (Hive) before rendering.

### 2) Dynamic Layout Rendering
**Assignment asks:** no hard-coded fixed UI layout, support 2+2 / 1+2 / extensibility.

Implemented in:
- Dynamic layout resolver and row/column grouping:
  - [lib/features/seat_selection/presentation/widgets/seat_map_view.dart](../lib/features/seat_selection/presentation/widgets/seat_map_view.dart)

Why this satisfies the requirement:
- `_SeatLayoutConfig.resolve` supports explicit layout types (`2+2`, `1+2`).
- If layout type is missing, it derives a layout from seat-number letter distribution.
- Renderer builds rows/sections generically from parsed data, not fixed hard-coded seat widgets.

### 3) Seat State Handling
**Assignment asks:** Available / Booked / Selected behavior and visuals.

Implemented in:
- Domain seat states:
  - [lib/features/seat_selection/domain/entities/seat_entity.dart](../lib/features/seat_selection/domain/entities/seat_entity.dart)
- Selection rules and max 2 seats:
  - [lib/features/seat_selection/presentation/providers/seat_selection_provider.dart](../lib/features/seat_selection/presentation/providers/seat_selection_provider.dart)
- State to visual mapping:
  - [lib/features/seat_selection/presentation/widgets/seat_map_view.dart](../lib/features/seat_selection/presentation/widgets/seat_map_view.dart)
  - [lib/config/theme/app_colors.dart](../lib/config/theme/app_colors.dart)

Why this satisfies the requirement:
- Booked seats are blocked in `toggleSeat`.
- Selected seats can be deselected by tapping again.
- Colors are centralized in theme mapping, not scattered hard-coded values.

### 4) Real-Time Pricing Summary
**Assignment asks:** sticky footer/bottom sheet with seat list + total, live updates.

Implemented in:
- Footer UI:
  - [lib/features/seat_selection/presentation/widgets/seat_selection_bottom_bar.dart](../lib/features/seat_selection/presentation/widgets/seat_selection_bottom_bar.dart)
- Real-time computed state:
  - [lib/features/seat_selection/presentation/providers/seat_selection_state.dart](../lib/features/seat_selection/presentation/providers/seat_selection_state.dart)
- Footer wiring to reactive provider state:
  - [lib/features/seat_selection/presentation/widgets/seat_selection_interactive_section.dart](../lib/features/seat_selection/presentation/widgets/seat_selection_interactive_section.dart)

Why this satisfies the requirement:
- Selected seats and `totalPrice` are computed from active state and re-render immediately.
- Continue button enables/disables based on selection.

### 5) Technical & Architectural Requirements

#### State Management (Riverpod)
- Providers/notifiers are used across features:
  - [lib/features/onboarding/presentation/providers/onboarding_flow_provider.dart](../lib/features/onboarding/presentation/providers/onboarding_flow_provider.dart)
  - [lib/features/home/presentation/providers/ticket_results_provider.dart](../lib/features/home/presentation/providers/ticket_results_provider.dart)
  - [lib/features/seat_selection/presentation/providers/seat_selection_provider.dart](../lib/features/seat_selection/presentation/providers/seat_selection_provider.dart)

#### Clean Architecture + Module Separation
- Domain/Data/Presentation split per feature is present under `lib/features/*`.
- Usecases and repository interfaces are defined in `domain`, implementations in `data`.

#### Dependency Injection
- Single registration point:
  - [lib/core/di/injector.dart](../lib/core/di/injector.dart)

#### GraphQL Data Flow + Error Handling
- GraphQL operation + map/parse + exception conversion pattern:
  - [lib/features/seat_selection/data/data_sources/local/seat_selection_local_data_source.dart](../lib/features/seat_selection/data/data_sources/local/seat_selection_local_data_source.dart)
  - [lib/core/error/exceptions.dart](../lib/core/error/exceptions.dart)
  - [lib/core/error/failures.dart](../lib/core/error/failures.dart)

#### Type-safe Models
- `freezed` and `json_serializable` models are used in app layers, for example:
  - [lib/features/seat_selection/data/models/seat_model.dart](../lib/features/seat_selection/data/models/seat_model.dart)
  - [lib/features/home/presentation/models/ticket_option.dart](../lib/features/home/presentation/models/ticket_option.dart)
  - [lib/features/home/presentation/providers/ticket_results_provider.freezed.dart](../lib/features/home/presentation/providers/ticket_results_provider.freezed.dart)

## UI/UX and Interaction Notes
- Seat map interaction is smooth and responsive via animated seat tiles and clear visual state transitions.
- Search, ticket flow, and seat booking are separated into focused screens.
- Recent hardening includes past-date booking guard:
  - [lib/features/home/presentation/widgets/home_search_section.dart](../lib/features/home/presentation/widgets/home_search_section.dart)
  - [lib/features/home/presentation/pages/ticket_results_page.dart](../lib/features/home/presentation/pages/ticket_results_page.dart)

## Testing and Quality Gates
Current suite includes unit, widget, and integration tests.

Examples:
- Usecase tests with Mockito:
  - [test/features/home/domain/usecases/home_usecases_mockito_test.dart](../test/features/home/domain/usecases/home_usecases_mockito_test.dart)
  - [test/features/seat_selection/domain/usecases/seat_selection_usecases_mockito_test.dart](../test/features/seat_selection/domain/usecases/seat_selection_usecases_mockito_test.dart)
  - [test/features/onboarding/domain/usecases/onboarding_usecases_mockito_test.dart](../test/features/onboarding/domain/usecases/onboarding_usecases_mockito_test.dart)
  - [test/features/splash/domain/usecases/resolve_splash_destination_usecase_mockito_test.dart](../test/features/splash/domain/usecases/resolve_splash_destination_usecase_mockito_test.dart)
- Widget tests:
  - [test/features/home/presentation/pages/home_page_test.dart](../test/features/home/presentation/pages/home_page_test.dart)
  - [test/features/home/presentation/pages/ticket_results_page_test.dart](../test/features/home/presentation/pages/ticket_results_page_test.dart)
  - [test/features/seat_selection/presentation/pages/seat_selection_page_test.dart](../test/features/seat_selection/presentation/pages/seat_selection_page_test.dart)
- Integration tests:
  - [integration_test/router_setup_test.dart](../integration_test/router_setup_test.dart)

CI workflow:
- Analyze + test + Android release build pipeline:
  - [.github/workflows/main.yml](../.github/workflows/main.yml)

## Deliverables and CI
- Android artifact generation exists in CI (`flutter build apk --release --split-per-abi`) and release upload.
- iOS workflow exists as scaffolded steps but currently commented.

## Future Extensibility Plan
1. Add new layout strategies by extending `_SeatLayoutConfig._parse` and plugging strategy classes per layout token.
2. Move seat pricing rules to backend response contract (per-class dynamic pricing, surge pricing windows).
3. Add server-backed GraphQL endpoint beside mock link with environment switching.
4. Add booking lifecycle states (reserved, paid, cancelled) and sync conflict resolution.
5. Add accessibility audit pass (semantics labels, larger tap targets, contrast checks).
6. Add CI coverage thresholds and automated screenshot/regression tests.

## Known Gaps / Next Improvements
- iOS release artifact generation should be enabled and signed in CI.
- Real backend integration can replace mock link for production deployment.
- More UI automation can be added for seat interactions at scale.
- Add API contract tests for GraphQL operation payload compatibility.
