# Changelog

All notable changes to the FiveM AI NPC Controller will be documented in this file.

## [1.2.0] - 2026-02-15

### Added
- **Framework Compatibility** - Added support for additional FiveM frameworks
  - Qbox framework integration (QBCore fork using qbx_core export)
  - ND-core framework integration with flexible job structure detection
  - Completed vRP framework integration with configurable group-to-job mapping
  - Added `Config.Compatibility.vRPGroupMapping` for customizable vRP group names
  - Added error handling with pcall for all framework integrations
  - Frameworks now checked in order with early return when job is found

### Changed
- Updated framework detection to prevent multiple frameworks from being checked unnecessarily
- Improved error handling for framework exports to prevent resource crashes
- ND-core integration now handles both string and nested job structures

## [1.1.1] - 2026-02-15

### Fixed
- **Emergency Vehicle Behavior System** - Fixed invalid FiveM natives
  - Fixed `TASK_VEHICLE_PULL_OVER` constant from incorrect value 27 to correct value 6
  - Removed invalid `SetHornEnabled()` native call (not available in FiveM)
  - Added documentation note that horn control is not implemented due to FiveM limitations
  - `StopPedSpeaking()` confirmed as valid and working correctly

### Changed
- Updated config documentation for `disableHornNearEmergency` to note it's not fully implemented

## [1.1.0] - 2026-02-14

### Added
- **Emergency Vehicle Behavior System** - Realistic NPC traffic response to emergency vehicles
  - NPCs pass stopped emergency vehicles (with lights on) slowly and cautiously
  - NPCs pull over when emergency vehicles approach from behind or in front
  - NPCs stop honking and talking when near emergency vehicles with lights activated
  - Fully configurable detection radius, response speeds, and pull-over duration
  - Works with police, ambulance, and fire truck emergency vehicles
  - Optional requirement for emergency lights/siren to be active
  - Configurable courtesy behavior radius
  - Direction detection (behind/front/side) for pull-over behavior
- Helper functions for emergency vehicle detection and behavior management
- Comprehensive configuration options in `emergencyVehicleBehavior` section

### Configuration
- `Config.VehicleSettings.emergencyVehicleBehavior` - New configuration section with 15+ options
- `slowPassEnabled`, `slowPassRadius`, `slowPassSpeed` - Control slow pass behavior
- `pullOverEnabled`, `pullOverDistance`, `pullOverDuration` - Control pull-over behavior
- `disableHornNearEmergency`, `disableSpeechNearEmergency` - Courtesy behavior settings
- `detectPolice`, `detectAmbulance`, `detectFiretruck` - Emergency vehicle type detection
- `requireSiren` - Require emergency lights to be on for NPC response

## [1.0.0] - 2026-02-14

### Added
- Initial release of FiveM AI NPC Controller
- Complete NPC population density control (peds, vehicles, parked vehicles, scenarios)
- Comprehensive spawn control settings
- NPC behavior configuration (reactions, combat, driving)
- Job-based NPC behavior system for RP servers
  - Police job respect and interaction
  - Medical job cooperation
  - Fire department response
  - Tow truck operator recognition
- Vehicle-specific controls (emergency vehicles, boats, planes, helicopters)
- Scenario and ambient NPC management
- Time-based NPC density settings
- Zone-based NPC customization
- Wanted system controls
- NPC relationship system
- Auto-cleanup system for performance optimization
- Framework integration (ESX, QBCore, vRP)
- Admin commands system
  - `/npcreload` - Reload configuration
  - `/npctoggle` - Toggle NPCs on/off
  - `/npcclear` - Clear all NPCs
  - `/npccount` - Show NPC count
- Server-side and client-side exports
- Debug mode and logging
- Model blacklist/whitelist system
- Custom event triggers
- Comprehensive configuration file with descriptions
- Full documentation and installation guide

### Features
- Over 100+ configurable options
- Standalone resource (no dependencies required)
- Optimized for performance
- Framework-agnostic with optional integrations
- Easy-to-use toggle system for all options
- Detailed comments and descriptions for every setting

### Compatibility
- FiveM build 2802 and above
- ESX Legacy and ESX 1.2+
- QBCore Framework
- vRP Framework
- Works on all server types (RP, Racing, PvP, Freeroam, etc.)

### Documentation
- Comprehensive README with feature list and examples
- Detailed INSTALLATION guide with common configurations
- Inline code documentation
- Configuration examples for different server types

### Performance
- Efficient update intervals
- Distance-based NPC management
- Automatic cleanup of distant NPCs
- Minimal resource usage (typically < 0.01ms)
- Configurable performance settings

## [Unreleased]

### Planned Features
- GUI configuration menu (in-game)
- Persistent configuration storage
- Per-player NPC settings
- More framework integrations
- Advanced zone shapes (polygons, not just radius)
- NPC spawn point customization
- Traffic pattern definitions
- Weather-based NPC behavior
- Event-based NPC spawning
- NPC group behavior settings

---

## Version Format

Versions follow [Semantic Versioning](https://semver.org/):
- MAJOR version for incompatible changes
- MINOR version for new functionality in a backwards compatible manner
- PATCH version for backwards compatible bug fixes

## Support

For bug reports, feature requests, or questions, please open an issue on GitHub:
https://github.com/ArmA3Cowboy/FiveM_AI_Controller/issues
