//
//  AnalyticsEventsConstants.swift
//  FocusTime
//
//  Created by Keto Nioradze on 06.09.25.
//

import Foundation

enum AnalyticsEventsConstants{
    // MARK: - AppFlowCoordinatorView
    enum AppFlowCoordinatorViewConstants {
        enum AnalyticsEvent: String {
            case appFlowOnboardingStarted = "app_flow_onboarding_started"
            case appFlowMainFlowStarted = "app_flow_main_flow_started"
            case appFlowSplashScreenShown = "app_flow_splash_screen_shown"

            case freePlanPaywall = "paywall_free_plan_shown"
            case onboardingPayWall = "paywall_onboarding_paywall_shown"
            case planSelectionPaywall = "paywall_plan_selection_paywall_shown"
            case paywallDismissed = "paywall_dismissed"
            case paywallRequestPlanSelections = "paywall_request_plan_selection"
            case paywallRequestFreePlan = "paywall_request_free_plan"
            case paywallRequestOnboarding = "paywall_request_onboarding"

            case onboardingFlowFinished = "onboarding_flow_finished"

            case paywallRequestPlanSelectionFromOtherPaywall = "paywall_request_plan_selection_from_other_paywall"
        }
    }

    // MARK: - MainFlowCoordinatorView
    enum MainFlowCoordinatorViewAnalyticsConstants {
        enum AnalyticsEvents: String {
            case mainFlowToFocusSession = "main_flow_to_focus_session"
            case mainFlowTabSelected = "main_flow_tab_selected"
        }

        enum AnalyticsEventsParameters: String {
            case tabName = "tab_name"
            case home = "Home"
            case drafts = "Drafts"
        }
    }
    
    // MARK: - FocusSessionView
    enum FocusSessionViewAnalyticsConstants {
        enum ScheduleSessionAnalyticsKeys: String {
            case startButtonTapped = "schedule_start_button_tapped"
            case saveButtonTapped = "schedule_save_button_tapped"
            case startFocusingButtonTapped = "schedule_start_focusing_button_tapped"
            case deleteButtonTapped = "schedule_delete_button_tapped"
            case deletionAlertPresented = "schedule_deletion_alert_presented"
            case errorVisibility = "schedule_error_visibility"
            case setSelectedEmoji = "schedule_set_selected_emoji"
            case setSelectedPreset = "schedule_set_selected_preset"
            case dismissed = "dismissed"
            case saveSelectedItemToStorage = "save_selected_item_to_storage"
        }
        
        enum ScheduleSessionAnalyticsParameterKey {
            static let presetName = "preset_name"
            static let durationHours = "duration_hours"
            static let durationMinutes = "duration_minutes"
            static let isScheduled = "is_scheduled"
            static let isDeletionAlertPresented = "is_deletion_alert_presented"
            static let isErrorVisible = "is_error_visible"
            static let setSelectedEmoji = "set_selected_emoji"
            static let selectedPreset = "selected_preset"
            static let presetNotSelected = "preset_not_selected"
        }
    }
    
    // MARK: - DraftsBlockItemListView
    enum DraftsBlockItemListViewAnalyticsConstants {
        enum AnalyticsEvents: String {
            case draftsErrorVisibilityChanged = "drafts_error_visibility_changed"
            case draftScreenLoaded = "draft_screen_loaded"
            case draftsNavigateNewFocusSession = "drafts_navigate_to_new_focus_session"
            case draftsNavigateEditFocusSession = "drafts_navigate_to_edit_focus_session"
            
        }
        
        enum AnalyticsEventsParameters: String {
            case isVisible = "is_visible"
        }
    }
    
    // MARK: - HomeView
    enum HomeViewAnalyticsConstants {
        enum AnalyticsEvents: String {
            case homeScreenErrorVisibilityChanged = "home_screen_error_visibility_changed"
            case homeScreenCheckAuthorization = "home_screen_check_authorization"
            case homeScreenShowFocusSessionSetup = "home_screen_show_focus_session_setup"
            case homeScreenShowScheduledFocus = "home_screen_show_scheduled_focus"
            case homeScreenShowTaskConcentration = "home_screen_show_task_concentration"
        }
        
        enum AnalyticsEventsParameters: String {
            case isVisible = "is_visible"
            case isPauseAction = "is_pause_action"
        }
    }
    
    // MARK: - ScheduledBlockItemsView
    enum ScheduledBlockItemsViewAnalyticsConstants {
        enum AnalyticsEvents: String {
            case scheduledListNavigateToNewFocusSession = "scheduled_list_navigate_to_new_focus_session"
            case scheduledListErrorVisibilityChanged = "scheduled_list_error_visibility_changed"
            case scheduledListScreenLoaded = "scheduled_list_screen_loaded"
        }
        
        enum AnalyticsEventsParameters: String {
            case isVisible = "is_visible"
        }
    }
    
    // MARK: - TaskConcentrationView
    enum TaskConcentrationViewAnalyticsConstants {
        enum AnalyticsEvents: String {
            case taskConcentrationErrorVisibilityChanged = "task_concentration_error_visibility_changed"
            case taskConcentrationStartBreakTimer = "task_concentration_start_break_timer"
            case taskConcentrationMoveToPauseScene = "task_concentration_move_to_pause_scene"
            case taskConcentrationMoveToBreakTimeAndSetupTimer = "task_concentration_move_to_break_time_and_setup_timer"
            case taskConcentrationMoveToEndSessionAlert = "task_concentration_move_to_end_session_alert"
            case taskConcentrationDismissed = "task_concentration_dismissed"
            case taskConcentrationEndBlock = "task_concentration_end_block"
        }
        
        enum AnalyticsEventsParameters: String {
            case isVisible = "is_visible"
        }
    }
    
    // MARK: - FreePlanUpgradeView
    enum PaywallViewModelsAnalyticsConstants {
        enum AnalyticsEvents: String {
            case freePlanUpgradePurchaseInitiated = "free_plan_upgrade_purchase_initiated"
            case freePlanUpgradeViewAllPlansTapped = "free_plan_upgrade_view_all_plans_tapped"
            
            case onboardingPaywallPurchaseInitiated = "onboarding_paywall_purchase_initiated"
            
            case planSelectionProductSelected = "plan_selection_product_selected"
            case planSelectionPurchaseInitiated = "plan_selection_purchase_initiated"
            
            case utilityLinksRestorePurchaseTapped = "utility_links_restore_purchase_tapped"
            case utilityLinksTermsOfServiceTapped = "utility_links_terms_of_service_tapped"
            case utilityLinksPrivacyPolicyTapped = "utility_links_privacy_policy_tapped"
            
            case superPaywallProductsFetched = "super_paywall_products_fetched"
            case superPaywallFetchFailed = "super_paywall_fetch_failed"
            case superPaywallPurchaseFailed = "super_paywall_purchase_failed"
            case superPaywallPurchaseSucceeded = "super_paywall_purchase_succeeded"
            case superPaywallPurchaseCancelled = "super_paywall_purchase_cancelled"
            case superPaywallPurchasePending = "super_paywall_purchase_pending"
        }
        
        enum AnalyticsEventsParameters: String {
            case productId = "product_id"
            case productCount = "product_count"
            case error = "error"
            case productNotFound = "product_not_found"
            case unknown = "unknown"
        }
    }
    
    // MARK: - SplashScreenView
    enum SplashScreenViewAnalyticsConstants {
        enum AnalyticsEvents: String {
            case splashScreenVideoPlayed = "splash_screen_video_played"
            case splashScreenAnimationStarted = "splash_screen_animation_started"
        }
    }
}
