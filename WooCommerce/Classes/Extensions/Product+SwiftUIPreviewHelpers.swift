#if canImport(SwiftUI) && DEBUG

import Yosemite

extension Product {
    /// Initializes a product with default properties.
    init() {
        self.init(siteID: 1,
                  productID: 2,
                  name: "Woo super cool shiny product",
                  slug: "",
                  permalink: "",
                  dateCreated: Date(),
                  dateModified: Date(),
                  dateOnSaleStart: Date(),
                  dateOnSaleEnd: Date(),
                  productTypeKey: ProductType.variable.rawValue,
                  statusKey: ProductStatus.draft.rawValue,
                  featured: false,
                  catalogVisibilityKey: ProductCatalogVisibility.hidden.rawValue,
                  fullDescription: "",
                  shortDescription: "",
                  sku: "sku",
                  price: "0",
                  regularPrice: "32.5",
                  salePrice: "17.6",
                  onSale: false,
                  purchasable: true,
                  totalSales: 0,
                  virtual: false,
                  downloadable: false,
                  downloads: [],
                  downloadLimit: -1,
                  downloadExpiry: -1,
                  buttonText: "",
                  externalURL: "",
                  taxStatusKey: ProductTaxStatus.taxable.rawValue,
                  taxClass: "",
                  manageStock: true,
                  stockQuantity: 32,
                  stockStatusKey: ProductStockStatus.inStock.rawValue,
                  backordersKey: ProductBackordersSetting.allowed.rawValue,
                  backordersAllowed: false,
                  backordered: false,
                  soldIndividually: true,
                  weight: "2.9",
                  dimensions: ProductDimensions(length: "12", width: "26", height: "16"),
                  shippingRequired: false,
                  shippingTaxable: false,
                  shippingClass: "",
                  shippingClassID: 0,
                  productShippingClass: nil,
                  reviewsAllowed: true,
                  averageRating: "4.30",
                  ratingCount: 23,
                  relatedIDs: [31, 22, 369, 414, 56],
                  upsellIDs: [99, 1234566],
                  crossSellIDs: [1234, 234234, 3],
                  parentID: 0,
                  purchaseNote: "Thank you!",
                  categories: [],
                  tags: [],
                  images: [],
                  attributes: [],
                  defaultAttributes: [],
                  variations: [],
                  groupedProducts: [],
                  menuOrder: 0)
    }
}

#endif
