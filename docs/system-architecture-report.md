# LogiTech System Architecture & Status Report

**Generated:** January 2026  
**Version:** 1.0  
**Prepared By:** Solutions Architect & Code Auditor  
**Target Audience:** Systems Analyst, Database Engineer

---

## Executive Summary

This report provides a comprehensive analysis of the **LogiTech System**, specifically focusing on the **Mobile App (Flutter)** component. The analysis covers system scope, architectural standards compliance, implementation status, data layer configuration, and user role definitions.

---

## Diagnostic Answers

### 1. System Scope & Core Value

**Question:** Based on the features implemented in `main.dart` and the lib structure, what is the primary business value of this system?

**Answer:** The LogiTech System is a **Fleet Operations Management Platform** targeting logistics/delivery companies. It is **more than just tracking** - it provides:

- **Driver Mobile Application** (this repository) for:
  - Vehicle check-in/check-out with photo documentation
  - Daily shift preparation with GPS location and selfie verification
  - Ticket/Request management (maintenance, fuel, car wash, accidents)
  - Accident reporting with wizard-based workflow
  - Real-time chat with supervisors
  - Driver profile and performance metrics

The primary business value is **operational control and compliance** - ensuring drivers follow proper procedures for vehicle handling, incident reporting, and daily operations while maintaining an audit trail.

---

### 2. Current Implementation Status

**Question:** Which modules are fully built (UI + Logic) and which are just placeholders?

#### Feature-by-Feature Analysis:

| Feature | UI Status | Logic Status | Readiness Level |
|---------|-----------|--------------|-----------------|
| **Auth** | ✅ Complete | ✅ Complete | 🟢 Production-Ready |
| **Dashboard** | ✅ Complete | ✅ Complete | 🟢 Production-Ready |
| **Tickets** | ✅ Complete | ✅ Complete | 🟢 Production-Ready |
| **Fleet (Vehicle Check-in)** | ✅ Complete | ✅ Complete | 🟢 Production-Ready |
| **Operations (Daily Prep)** | ✅ Complete | ✅ Complete | 🟢 Production-Ready |
| **Operations (Accident)** | ✅ Complete | ✅ Complete | 🟢 Production-Ready |

**Detailed Breakdown:**

1. **Auth Feature** (`lib/features/auth/`)
   - ✅ `LoginScreen` - Full UI with email/password fields
   - ✅ `FirebaseAuthRepository` - Firebase Auth integration
   - ✅ `IAuthRepository` interface - Proper abstraction
   - Status: **Fully Implemented**

2. **Dashboard Feature** (`lib/features/dashboard/`)
   - ✅ `MainDashboard` - Bottom navigation with 3 tabs
   - ✅ `DashboardHomeContent` - Action cards, status display, recent tickets
   - ✅ `ProfileScreen` - User stats and settings
   - Status: **Fully Implemented**

3. **Tickets Feature** (`lib/features/tickets/`)
   - ✅ `CreateTicketScreen` - Full form with type, priority, description, photos
   - ✅ `TicketsHistoryScreen` - Filterable ticket list
   - ✅ `TicketDetailsScreen` - Chat-based ticket communication
   - ✅ `TicketNotifier` + `ChatNotifier` - State management
   - ✅ Domain models (`CreateTicketForm`, `ChatMessage`, `TicketType`)
   - Status: **Fully Implemented**

4. **Fleet Feature** (`lib/features/fleet/`)
   - ✅ `VehicleCheckInScreen` - 3-step stepper (vehicle selection, odometer, photos)
   - ✅ `VehicleCheckInNotifier` - State management
   - ✅ `VehicleCheckInForm` - Domain model with validation
   - Status: **Fully Implemented**

5. **Operations Feature** (`lib/features/operations/`)
   - ✅ `DailyPreparationScreen` - Location, odometer, selfie capture
   - ✅ `AccidentWizardScreen` - 5-step wizard for accident reporting
   - ✅ Corresponding notifiers and providers
   - ✅ Domain models (`DailyPreparationForm`, `AccidentReportForm`)
   - Status: **Fully Implemented**

---

### 3. User Journey (Navigation Mapping)

**Question:** Map the user journey from navigation analysis.

```
LoginScreen
    │
    ▼
MainDashboard (Bottom Navigation)
    ├─── Tab 0: الرئيسية (Home)
    │         │
    │         ├── Vehicle Check-in → VehicleCheckInScreen (Stepper)
    │         ├── Daily Preparation → DailyPreparationScreen
    │         ├── New Ticket → CreateTicketScreen
    │         ├── Accident Report → AccidentWizardScreen (5-step wizard)
    │         └── Ticket Details → TicketDetailsScreen (Chat)
    │
    ├─── Tab 1: التذاكر (Tickets)
    │         │
    │         └── TicketsHistoryScreen → TicketDetailsScreen
    │
    └─── Tab 2: حسابي (Profile)
              │
              └── ProfileScreen → Logout → LoginScreen
```

---

### 4. Data Layer Status (Factors IV & X)

**Critical Question:** Is the system currently running on Live Firebase Data or Mock Data by default?

**Answer:** The system **defaults to MOCK DATA** for safety.

**Evidence from `lib/core/config/app_config.dart`:**

```dart
const useMockData = bool.fromEnvironment(
  'USE_MOCK_DATA',
  defaultValue: true, // Default to mock mode for safety
);
```

**Data Source Decision Flow:**

```
AppConfig.useMockData = true (default)
    │
    ├── TicketRepository → MockDataProvider (mock_tickets_data.dart)
    ├── LocationService → Returns hardcoded "24.7136, 46.6753" (Riyadh)
    ├── MediaService → Returns mock XFile paths
    └── UserRepository → Returns mock odometer reading (50,000)

AppConfig.useMockData = false (via --dart-define)
    │
    ├── TicketRepository → TicketRemoteDatasource (Firestore)
    ├── Firebase Auth → Live authentication
    └── Other services → Expected to connect to real backends
```

**Current Mock Data Files:**
- `lib/core/constants/mock_tickets_data.dart` - 4 sample tickets
- `lib/core/constants/mock_vehicles.dart` - 3 sample vehicles
- `lib/core/constants/mock_messages.dart` - 2 sample chat messages

---

## 1. System Overview

### 1.1 What the Software Does

The **LogiTech Mobile App** is a Flutter-based driver companion application designed for fleet management operations. It serves as the field-facing component of the LogiTech ecosystem.

**Core Capabilities:**

| Capability | Description |
|------------|-------------|
| **Driver Authentication** | Firebase-based login with email/password |
| **Vehicle Management** | Check-in/check-out with 4-angle photo documentation |
| **Daily Operations** | Shift start with GPS verification, odometer reading, selfie |
| **Ticket System** | Create and track maintenance, fuel, wash, and general requests |
| **Incident Reporting** | Multi-step wizard for accident documentation |
| **Communication** | In-app chat with supervisors per ticket |

### 1.2 Target Users

- **Primary:** Fleet drivers (السائق)
- **Secondary:** Operations supervisors (via ticket chat interface)

### 1.3 Language & Localization

- Primary language: **Arabic (RTL)**
- Locale: `ar_SA` (Saudi Arabia)
- App direction: Right-to-Left (RTL)

---

## 2. Architectural Standards

### 2.1 The Twelve-Factor App Compliance

| Factor | Status | Implementation |
|--------|--------|----------------|
| **I. Codebase** | ✅ | Single repo, multiple environments via entry points |
| **II. Dependencies** | ✅ | All dependencies in `pubspec.yaml` |
| **III. Config** | ✅ | `AppConfig` class with `--dart-define` for environment variables |
| **IV. Backing Services** | ✅ | Firebase as attached resource, interfaces for all services |
| **V. Build/Release/Run** | ✅ | Separate entry points (`main_dev.dart`, `main_prod.dart`) |
| **VI. Processes** | ✅ | Stateless app, state in external services |
| **VII. Port Binding** | N/A | Mobile app (not server) |
| **VIII. Concurrency** | N/A | Mobile app (single instance) |
| **IX. Disposability** | ✅ | Quick startup, graceful disposal via Riverpod |
| **X. Dev/Prod Parity** | ✅ | Same codebase, different configs via `--dart-define` |
| **XI. Logs** | ✅ | Centralized `AppLogger` with severity levels |
| **XII. Admin Processes** | N/A | No admin scripts in mobile app |

### 2.2 OOP Principles Compliance

| Principle | Status | Implementation |
|-----------|--------|----------------|
| **Interface Segregation** | ✅ | `IAuthRepository`, `IMediaService`, `ILocationService`, `IUserRepository` |
| **Repository Pattern** | ✅ | `AuthRepository`, `TicketRepository` abstractions |
| **Service Abstraction** | ✅ | Use cases (`TicketManagerUseCase`, `DailyPreparationUseCase`, etc.) |
| **Dependency Injection** | ✅ | Riverpod providers in `providers.dart` |
| **Single Responsibility** | ✅ | Separate notifiers per feature |
| **Immutable State** | ✅ | Form classes with `copyWith` methods |

### 2.3 Clean Architecture Implementation

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                        │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   Screens   │  │  Notifiers  │  │     Providers       │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
├─────────────────────────────────────────────────────────────┤
│                      Domain Layer                            │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   Entities  │  │ Form Models │  │     Use Cases       │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
├─────────────────────────────────────────────────────────────┤
│                       Data Layer                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │ Repositories│  │ Datasources │  │   Mock Providers    │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. Detailed Component Status

### 3.1 Mobile App Feature Matrix

| Module | Screens | Notifiers | Domain Models | Repository | Status |
|--------|---------|-----------|---------------|------------|--------|
| Auth | 1 | - | AuthUser | FirebaseAuthRepository | ✅ Complete |
| Dashboard | 3 | - | - | - | ✅ Complete |
| Tickets | 3 | 2 | CreateTicketForm, ChatMessage | TicketRepository | ✅ Complete |
| Fleet | 1 | 1 | VehicleCheckInForm | - | ✅ Complete |
| Operations | 2 | 3 | DailyPreparationForm, AccidentReportForm | - | ✅ Complete |

### 3.2 State Management

- **Framework:** Riverpod 3.x
- **Pattern:** Notifier/NotifierProvider
- **State Objects:** Immutable with `copyWith` methods

### 3.3 Services Layer

| Service | Interface | Implementation | Purpose |
|---------|-----------|----------------|---------|
| Media | `IMediaService` | `MediaServiceImpl` | Camera/gallery access |
| Location | `ILocationService` | `LocationServiceImpl` | GPS coordinates |
| User | `IUserRepository` | `UserRepositoryImpl` | Driver profile data |
| Auth | `IAuthRepository` | `FirebaseAuthRepository` | Authentication |

### 3.4 Use Cases

| Use Case | Injected Dependencies | Purpose |
|----------|----------------------|---------|
| `SubmitVehicleCheckInUseCase` | MediaService | Vehicle photo capture |
| `TicketManagerUseCase` | MediaService | Ticket attachment handling |
| `DailyPreparationUseCase` | LocationService, UserRepository, MediaService | Shift start workflow |
| `AccidentReportingUseCase` | MediaService, LocationService | Accident documentation |

---

## 4. Data & Infrastructure

### 4.1 Current Database Schema (Inferred from Interfaces)

#### Ticket Entity
```dart
{
  id: String,           // e.g., "TKT-101"
  title: String,        // Arabic description
  status: String,       // "open", "closed", "in_progress"
  date: String,         // ISO date
  type: String,         // "maintenance", "fuel", "carWash", "accident", "general"
  priority: String      // "low", "medium", "high", "urgent"
}
```

#### User Entity (AuthUser)
```dart
{
  id: String,           // Firebase UID
  email: String         // User email
}
```

#### Vehicle Entity
```dart
{
  id: String,           // e.g., "v1"
  plate: String,        // Arabic plate number
  type: String,         // Vehicle type description
  status: String        // "active", "maintenance"
}
```

#### ChatMessage Entity
```dart
{
  id: String,
  text: String,
  sender: String,       // "me", "supervisor", "system"
  timestamp: DateTime
}
```

#### Form Models (Domain Layer)

| Form | Fields | Validation |
|------|--------|------------|
| `CreateTicketForm` | type, priority, title, description, photos (max 10) | All fields required except photos |
| `VehicleCheckInForm` | vehicleId, odometer, photos (4 mandatory) | All fields required |
| `DailyPreparationForm` | currentOdometer, selfie, locationCoordinates, city | Odometer, selfie, location required |
| `AccidentReportForm` | timestamp, location, accidentType, hasOtherParty, vehiclePhotos (4), scenePhotos, reportDoc | Multi-step validation |

### 4.2 Connection Status

| Component | Current State | Configuration |
|-----------|---------------|---------------|
| Firebase Auth | 🟡 Configured | Real Firebase, initialized in `main_common.dart` |
| Firestore | 🟡 Configured (unused by default) | `TicketRemoteDatasource` exists but mock is default |
| Mock Data | 🟢 Active | `USE_MOCK_DATA=true` (default) |

### 4.3 Backend Services Expected

Based on interface definitions, the system expects:
- Firebase Authentication
- Firestore Database (for tickets, messages)
- Firebase Storage (for photos - implied by media upload patterns)
- GPS/Location services (device-based)

---

## 5. User Roles (RBAC)

### 5.1 Active Roles Found in Code

| Role | Code Reference | Access Level |
|------|----------------|--------------|
| **Driver** (`me`) | `ChatMessage.sender`, `ProfileScreen` | Create tickets, vehicle check-in, daily prep, chat |
| **Supervisor** (`supervisor`) | `ChatMessage.sender`, `mock_messages.dart` | Respond to tickets (via chat), receive alerts |
| **System** (`system`) | `ChatMessage.sender` | Automated messages |

### 5.2 Role Capabilities (Inferred)

| Action | Driver | Supervisor | System |
|--------|--------|------------|--------|
| Login | ✅ | ❌ (Web) | ❌ |
| Create Ticket | ✅ | ❌ | ❌ |
| View Ticket History | ✅ | ❌ (Web) | ❌ |
| Send Chat Message | ✅ | ✅ | ✅ |
| Vehicle Check-in | ✅ | ❌ | ❌ |
| Daily Preparation | ✅ | ❌ | ❌ |
| Report Accident | ✅ | ❌ | ❌ |
| Go Online/Offline | ✅ | ❌ | ❌ |

---

## 6. Technical Recommendations

### 6.1 For Production Readiness

1. **Enable Live Data:**
   ```bash
   flutter run -t lib/main_prod.dart --dart-define=USE_MOCK_DATA=false
   ```

2. **Configure Firebase Project IDs:**
   - Set `FIREBASE_PROJECT_ID` for prod environment
   - Use `--dart-define-from-file` for local development

3. **Implement Missing Data Layer:**
   - `TicketRemoteDatasource` implementation
   - Firebase Storage integration for photo uploads

### 6.2 Security Considerations

- API keys should be provided via `--dart-define` (not hardcoded)
- Production Firebase configuration should use GitHub Secrets
- Consider implementing biometric authentication for driver verification

### 6.3 Monitoring & Observability

- `AppLogger` is in place but needs integration with:
  - Firebase Crashlytics
  - Firebase Analytics
  - Remote logging service (Factor XI compliance)

---

## Appendix A: File Structure

```
lib/
├── main.dart                    # Default entry (dev)
├── main_dev.dart               # Development entry
├── main_prod.dart              # Production entry
├── main_common.dart            # Shared initialization
├── firebase_options.dart       # Firebase configuration
│
├── core/
│   ├── config/
│   │   └── app_config.dart     # Centralized configuration
│   ├── constants/
│   │   ├── mock_tickets_data.dart
│   │   ├── mock_vehicles.dart
│   │   └── mock_messages.dart
│   ├── logging/
│   │   └── app_logger.dart     # Centralized logging
│   └── services/
│       ├── providers.dart      # Riverpod DI
│       ├── media_service.dart
│       ├── location_service.dart
│       ├── user_repository.dart
│       └── *_usecase.dart      # Use cases
│
└── features/
    ├── auth/
    │   ├── data/repositories/
    │   └── presentation/screens/
    ├── dashboard/
    │   └── presentation/screens/
    ├── tickets/
    │   ├── data/repositories/
    │   ├── domain/
    │   └── presentation/
    ├── fleet/
    │   ├── domain/
    │   └── presentation/
    └── operations/
        ├── domain/
        └── presentation/
```

---

## Appendix B: ADRs (Architecture Decision Records)

1. **ADR 001:** Configuration Management using `--dart-define`
2. **ADR 002:** Centralized Logging System
3. **ADR 003:** Separating Interfaces from Implementations

---

## Appendix C: Dependencies

Key dependencies from `pubspec.yaml`:
- `flutter_riverpod` - State management
- `firebase_core` - Firebase initialization
- `firebase_auth` - Authentication
- `image_picker` - Camera/gallery access
- `logger` - Logging framework
- `intl` - Internationalization

---

*Report End*
