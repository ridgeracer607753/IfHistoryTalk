import Foundation

enum VersionCheckResult {
    case latest         // 최신 버전임
    case updateOptional // 선택적 업데이트 권장
    case updateRequired // 강제 업데이트 필요
}

protocol VersionCheckService {
    func checkVersion() async -> VersionCheckResult
}

// Firebase SDK 추가 전까지 사용할 임시 서비스
class MockVersionCheckService: VersionCheckService {
    func checkVersion() async -> VersionCheckResult {
        // 테스트를 위해 강제로 결과를 바꾸고 싶을 때 여기서 수정 가능
        try? await Task.sleep(nanoseconds: 1 * 1_000_000_000) // 1초 대기 (네트워크 흉내)
        return .latest
    }
}

// 나중에 Firebase SDK 추가 후 사용할 실제 서비스 (미리 작성)
/*
import FirebaseRemoteConfig

class FirebaseVersionCheckService: VersionCheckService {
    func checkVersion() async -> VersionCheckResult {
        let remoteConfig = RemoteConfig.remoteConfig()
        
        do {
            try await remoteConfig.fetchAndActivate()
            
            let minVersion = remoteConfig["min_version"].stringValue ?? "1.0.0"
            let latestVersion = remoteConfig["latest_version"].stringValue ?? "1.0.0"
            let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
            
            // 버전 비교 로직 (단순 예시)
            if currentVersion.compare(minVersion, options: .numeric) == .orderedAscending {
                return .updateRequired
            } else if currentVersion.compare(latestVersion, options: .numeric) == .orderedAscending {
                return .updateOptional
            } else {
                return .latest
            }
        } catch {
            return .latest // 에러 시에는 우선 진행
        }
    }
}
*/
