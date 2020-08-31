import UIKit

@available(iOS 13.0, *)
extension UITableViewDiffableDataSource {
    func indexOfItem(for indexPath: IndexPath) -> Int? {
        guard let identifier = itemIdentifier(for: indexPath) else {
            return nil
        }

        return snapshot().indexOfItem(identifier)
    }

    var numberOfItems: Int {
        snapshot().numberOfItems
    }

    func sectionIdentifier(for sectionIndex: Int) -> SectionIdentifierType? {
        snapshot().sectionIdentifiers[safe: sectionIndex]
    }
}
