struct DefaultFeatureFlagService: FeatureFlagService {
    func isFeatureFlagEnabled(_ featureFlag: FeatureFlag) -> Bool {
        let buildConfig = BuildConfiguration.current

        switch featureFlag {
        case .barcodeScanner:
            return buildConfig == .localDeveloper || buildConfig == .alpha
        case .editProductsRelease3:
            return buildConfig == .localDeveloper || buildConfig == .alpha
        case .editProductsRelease4:
            return buildConfig == .localDeveloper || buildConfig == .alpha
        case .refunds:
            return true
        default:
            return true
        }
    }
}
