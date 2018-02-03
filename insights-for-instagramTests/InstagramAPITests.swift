import Quick
import Nimble
import Alamofire
@testable
import insights_for_instagram
import Moya

class InstagramAPITests: QuickSpec {
    override func spec() {
        var provider: MoyaProvider<Instagram>!
        beforeEach {
            provider = MoyaProvider<Instagram>(stubClosure: MoyaProvider.immediatelyStub)
        }
        it("returns stubbed data for user media request") {
            var json: String?
            let target: Instagram = .userMedia("")
            provider.request(target) { result in
                if case let .success(response) = result {
                    json = String(data: response.data, encoding: .utf8)
                }
            }
            let sampleData = String(data: target.sampleData, encoding: .utf8)
            expect(json).to(equal(sampleData))
        }
    }
}
