// Generated Localizations
export 'src/generated/wallet_localizations.dart';

// Domain Entities
export 'src/domain/entities/wallet_entity.dart';
export 'src/domain/entities/wallet_details_entity.dart';

// Domain Repository
export 'src/domain/repositories/wallet_repository.dart';

// Domain UseCases
export 'src/domain/usecases/get_wallets_usecase.dart';
export 'src/domain/usecases/add_wallets_usecase.dart';
export 'src/domain/usecases/delete_wallet_usecase.dart';
export 'src/domain/usecases/get_wallet_details_usecase.dart';
export 'src/domain/usecases/reset_wallet_stats_usecase.dart';
export 'src/domain/usecases/update_wallet_balance_usecase.dart';

// Data Models & Cache
export 'src/data/models/wallet_dto.dart';
export 'src/data/cache/wallet_meta_cache.dart';
export 'src/data/datasources/wallet_remote_data_source.dart';
export 'src/data/datasources/wallet_remote_data_source_impl.dart';
export 'src/data/datasources/wallet_details_remote_data_source.dart';
export 'src/data/datasources/wallet_details_remote_data_source_impl.dart';
export 'src/data/repositories/wallet_repository_impl.dart';

// Presentation Providers & State
export 'src/presentation/providers/wallet_providers.dart';
export 'src/presentation/providers/add_wallet_state.dart';
export 'src/presentation/providers/add_wallet_controller.dart';
export 'src/presentation/providers/wallet_details_controller.dart';
export 'src/presentation/providers/wallet_balance_edit_controller.dart';

// Presentation Screens
export 'src/presentation/screens/add_wallet_screen.dart';
export 'src/presentation/screens/details_screen.dart';

// Presentation Widgets
export 'src/presentation/widgets/shared/provider_icon.dart';
export 'src/presentation/widgets/shared/provider_info.dart';
export 'src/presentation/widgets/shared/summary_tile.dart';
export 'src/presentation/widgets/shared/summary_card.dart';
export 'src/presentation/widgets/details/balance_card.dart';
export 'src/presentation/widgets/details/balance_section.dart';
export 'src/presentation/widgets/details/edit_balance_bottom_sheet.dart';
export 'src/presentation/widgets/add_wallet/add_wallet_content.dart';
export 'src/presentation/widgets/add_wallet/phone_number_section.dart';
export 'src/presentation/widgets/add_wallet/provider_grid.dart';

// Presentation Utilities
export 'src/presentation/utils/amount_extension.dart';
export 'src/presentation/utils/date_extensions.dart';
export 'src/presentation/utils/provider_ext.dart';
export 'src/presentation/utils/localization_extension.dart';
