import Foundation
import CoreData

protocol MyTBAManaged: Managed {
    associatedtype MyType: NSManagedObject
    associatedtype RemoteType: MyTBAModel

    @discardableResult static func insert(_ model: RemoteType, in context: NSManagedObjectContext) -> MyType
    func toRemoteModel() -> RemoteType
}

extension MyTBAEntity: Managed {

    var isOrphaned: Bool {
        // We manage the deletion of these objects ourselves
        return false
    }

}