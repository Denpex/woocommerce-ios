import Yosemite

/// Edit actions in the product form. Each action allows the user to edit a subset of product properties.
enum ProductFormEditAction {
    case images
    case name
    case description
    case priceSettings
    case reviews
    case productType
    case inventorySettings
    case shippingSettings
    case categories
    case tags
    case briefDescription
    // Affiliate products only
    case sku
    case externalURL
    // Grouped products only
    case groupedProducts
    // Variable products only
    case variations
    // Variation only
    case variationName
    case noPriceWarning
    case status
    // Non-core products only (e.g. subscription products, booking products)
    case readonlyPriceSettings
    case readonlyInventorySettings
}

/// Creates actions for different sections/UI on the product form.
struct ProductFormActionsFactory: ProductFormActionsFactoryProtocol {
    private let product: EditableProductModel
    private let isEditProductsRelease3Enabled: Bool

    init(product: EditableProductModel,
         isEditProductsRelease3Enabled: Bool) {
        self.product = product
        self.isEditProductsRelease3Enabled = isEditProductsRelease3Enabled
    }

    /// Returns an array of actions that are visible in the product form primary section.
    func primarySectionActions() -> [ProductFormEditAction] {
        return [
            .images,
            .name,
            .description
        ]
    }

    /// Returns an array of actions that are visible in the product form settings section.
    func settingsSectionActions() -> [ProductFormEditAction] {
        return visibleSettingsSectionActions()
    }

    /// Returns an array of actions that are visible in the product form bottom sheet.
    func bottomSheetActions() -> [ProductFormBottomSheetAction] {
        return allSettingsSectionActions().filter { settingsSectionActions().contains($0) == false }
            .compactMap { ProductFormBottomSheetAction(productFormAction: $0) }
    }
}

private extension ProductFormActionsFactory {
    /// All the editable actions in the settings section given the product and feature switches.
    func allSettingsSectionActions() -> [ProductFormEditAction] {
        switch product.product.productType {
        case .simple:
            return allSettingsSectionActionsForSimpleProduct()
        case .affiliate:
            return allSettingsSectionActionsForAffiliateProduct()
        case .grouped:
            return allSettingsSectionActionsForGroupedProduct()
        case .variable:
            return allSettingsSectionActionsForVariableProduct()
        default:
            return allSettingsSectionActionsForNonCoreProduct()
        }
    }

    func allSettingsSectionActionsForSimpleProduct() -> [ProductFormEditAction] {
        let shouldShowReviewsRow = isEditProductsRelease3Enabled && product.reviewsAllowed
        let shouldShowProductTypeRow = isEditProductsRelease3Enabled
        let shouldShowShippingSettingsRow = product.isShippingEnabled()
        let shouldShowCategoriesRow = isEditProductsRelease3Enabled
        let shouldShowTagsRow = isEditProductsRelease3Enabled

        let actions: [ProductFormEditAction?] = [
            .priceSettings,
            shouldShowReviewsRow ? .reviews: nil,
            shouldShowShippingSettingsRow ? .shippingSettings: nil,
            .inventorySettings,
            shouldShowCategoriesRow ? .categories: nil,
            shouldShowTagsRow ? .tags: nil,
            .briefDescription,
            shouldShowProductTypeRow ? .productType : nil
        ]
        return actions.compactMap { $0 }
    }

    func allSettingsSectionActionsForAffiliateProduct() -> [ProductFormEditAction] {
        let shouldShowReviewsRow = isEditProductsRelease3Enabled && product.reviewsAllowed
        let shouldShowProductTypeRow = isEditProductsRelease3Enabled
        let shouldShowCategoriesRow = isEditProductsRelease3Enabled
        let shouldShowTagsRow = isEditProductsRelease3Enabled

        let actions: [ProductFormEditAction?] = [
            .priceSettings,
            shouldShowReviewsRow ? .reviews: nil,
            .externalURL,
            .sku,
            shouldShowCategoriesRow ? .categories: nil,
            shouldShowTagsRow ? .tags: nil,
            .briefDescription,
            shouldShowProductTypeRow ? .productType : nil
        ]
        return actions.compactMap { $0 }
    }

    func allSettingsSectionActionsForGroupedProduct() -> [ProductFormEditAction] {
        let shouldShowReviewsRow = isEditProductsRelease3Enabled && product.reviewsAllowed
        let shouldShowProductTypeRow = isEditProductsRelease3Enabled
        let shouldShowCategoriesRow = isEditProductsRelease3Enabled
        let shouldShowTagsRow = isEditProductsRelease3Enabled

        let actions: [ProductFormEditAction?] = [
            .groupedProducts,
            shouldShowReviewsRow ? .reviews: nil,
            .sku,
            shouldShowCategoriesRow ? .categories: nil,
            shouldShowTagsRow ? .tags: nil,
            .briefDescription,
            shouldShowProductTypeRow ? .productType : nil
        ]
        return actions.compactMap { $0 }
    }

    func allSettingsSectionActionsForVariableProduct() -> [ProductFormEditAction] {
        let shouldShowReviewsRow = isEditProductsRelease3Enabled && product.reviewsAllowed
        let shouldShowProductTypeRow = isEditProductsRelease3Enabled
        let shouldShowCategoriesRow = isEditProductsRelease3Enabled
        let shouldShowTagsRow = isEditProductsRelease3Enabled

        let actions: [ProductFormEditAction?] = [
            .variations,
            shouldShowReviewsRow ? .reviews: nil,
            .shippingSettings,
            .inventorySettings,
            shouldShowCategoriesRow ? .categories: nil,
            shouldShowTagsRow ? .tags: nil,
            .briefDescription,
            shouldShowProductTypeRow ? .productType : nil
        ]
        return actions.compactMap { $0 }
    }

    func allSettingsSectionActionsForNonCoreProduct() -> [ProductFormEditAction] {
        let shouldShowPriceSettingsRow = product.regularPrice.isNilOrEmpty == false
        let shouldShowReviewsRow = isEditProductsRelease3Enabled && product.reviewsAllowed
        let shouldShowProductTypeRow = isEditProductsRelease3Enabled
        let shouldShowCategoriesRow = isEditProductsRelease3Enabled
        let shouldShowTagsRow = isEditProductsRelease3Enabled

        let actions: [ProductFormEditAction?] = [
            shouldShowPriceSettingsRow ? .readonlyPriceSettings: nil,
            shouldShowReviewsRow ? .reviews: nil,
            .readonlyInventorySettings,
            shouldShowCategoriesRow ? .categories: nil,
            shouldShowTagsRow ? .tags: nil,
            .briefDescription,
            shouldShowProductTypeRow ? .productType : nil
        ]
        return actions.compactMap { $0 }
    }
}

private extension ProductFormActionsFactory {
    func visibleSettingsSectionActions() -> [ProductFormEditAction] {
        return allSettingsSectionActions().compactMap({ $0 }).filter({ isVisibleInSettingsSection(action: $0) })
    }

    func isVisibleInSettingsSection(action: ProductFormEditAction) -> Bool {
        switch action {
        case .priceSettings:
            // The price settings action is always visible in the settings section.
            return true
        case .reviews:
            // The reviews action is always visible in the settings section.
            return true
        case .productType:
            // The product type action is always visible in the settings section.
            return true
        case .inventorySettings:
            let hasStockData = product.manageStock ? product.stockQuantity != nil: true
            return product.sku != nil || hasStockData
        case .shippingSettings:
            return product.weight.isNilOrEmpty == false ||
                product.dimensions.height.isNotEmpty || product.dimensions.width.isNotEmpty || product.dimensions.length.isNotEmpty
        case .categories:
            return product.product.categories.isNotEmpty
        case .tags:
            return product.product.tags.isNotEmpty
        case .briefDescription:
            return product.shortDescription.isNilOrEmpty == false
        // Affiliate products only.
        case .externalURL:
            // The external URL action is always visible in the settings section for an affiliate product.
            return true
        case .sku:
            return product.sku?.isNotEmpty == true
        // Grouped products only.
        case .groupedProducts:
            // The grouped products action is always visible in the settings section for a grouped product.
            return true
        // Variable products only.
        case .variations:
            // The variations row is always visible in the settings section for a variable product.
            return true
        // Non-core products only.
        case .readonlyPriceSettings, .readonlyInventorySettings:
            // The readonly rows are always visible in the settings section for a non-core product.
            return true
        default:
            return false
        }
    }
}
