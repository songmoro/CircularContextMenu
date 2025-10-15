# CircularContextMenu

iOS 앱을 위한 커스터마이징 가능한 원형 컨텍스트 메뉴 라이브러리입니다. 롱 프레스와 탭 제스처를 지원하는 직관적인 원형 메뉴 인터페이스를 제공합니다.

[English](README.md) | 한국어

## 스크린샷

<p align="center">
  <img src="Screenshots/screenshot1.png" width="250" alt="초기 화면">
  <img src="Screenshots/screenshot2.png" width="250" alt="왼쪽 롱 프레스 메뉴">
  <img src="Screenshots/screenshot3.png" width="250" alt="오른쪽 롱 프레스 메뉴">
</p>

## 주요 기능

- **원형 레이아웃**: 터치 포인트를 중심으로 원형 배치되는 메뉴 아이템
- **제스처 지원**: 롱 프레스(드래그하여 선택)와 탭 방식 모두 지원
- **뷰 하이라이팅**: 메뉴 표시 시 선택적 시각 효과
- **커스터마이징**: 색상, 크기, 애니메이션 등 자유로운 설정
- **순수 UIKit**: 외부 의존성 없음
- **부드러운 애니메이션**: 세련된 표시 및 제거 애니메이션
- **스마트 포지셔닝**: 화면 밖으로 나가지 않도록 자동 조정

## 요구사항

- iOS 16.0+
- Swift 5.9+
- Xcode 15.0+

## 설치

### Swift Package Manager

Xcode를 통해 프로젝트에 CircularContextMenu를 추가하세요:

1. File > Add Package Dependencies
2. 저장소 URL 입력: `https://github.com/songmoro/CircularContextMenu.git`
3. 버전 요구사항 선택

또는 `Package.swift`에 직접 추가:

```swift
dependencies: [
    .package(url: "https://github.com/songmoro/CircularContextMenu.git", from: "0.1.0")
]
```

### CocoaPods

`Podfile`에 추가:

```ruby
pod 'CircularContextMenu', '~> 0.1.0'
```

설치 실행:

```bash
pod install
```

## 사용법

### 기본 롱 프레스 메뉴

```swift
import CircularContextMenu

// 메뉴 아이템 정의
let items: [CircularMenuItemProtocol] = [
    CircularMenuItem(
        name: "편집",
        image: UIImage(systemName: "pencil"),
        backgroundColor: .systemYellow
    ) {
        print("편집 선택됨")
    },
    CircularMenuItem(
        name: "삭제",
        image: UIImage(systemName: "trash"),
        backgroundColor: .systemRed
    ) {
        print("삭제 선택됨")
    },
    CircularMenuItem(
        name: "공유",
        image: UIImage(systemName: "square.and.arrow.up"),
        backgroundColor: .systemBlue
    ) {
        print("공유 선택됨")
    }
]

// 뷰에 롱 프레스 메뉴 추가
CircularMenuManager.shared.addLongPressMenu(
    to: myView,
    targetView: myView,
    items: items,
    presentingViewController: self
)
```

### 탭 메뉴

드래그 대신 탭하여 선택하는 메뉴:

```swift
CircularMenuManager.shared.addTapMenu(
    to: myView,
    targetView: myView,
    items: items,
    presentingViewController: self
)
```

### 수동 표시

특정 위치에 메뉴를 직접 표시할 수도 있습니다:

```swift
CircularMenuManager.shared.showMenu(
    at: CGPoint(x: 200, y: 300),
    selectedView: myView,
    items: items,
    from: self
)
```

## 커스터마이징

### 뷰 하이라이팅

메뉴가 나타날 때 선택된 뷰의 하이라이트 방식을 설정합니다:

```swift
// 컨텍스트 회전 (기본값)
CircularMenuManager.shared.addLongPressMenu(
    to: myView,
    targetView: myView,
    items: items,
    presentingViewController: self,
    highlightConfiguration: .withContextualRotation()
)

// 스케일 효과
CircularMenuManager.shared.addLongPressMenu(
    to: myView,
    targetView: myView,
    items: items,
    presentingViewController: self,
    highlightConfiguration: .withScale
)

// 커스텀 회전 각도
CircularMenuManager.shared.addLongPressMenu(
    to: myView,
    targetView: myView,
    items: items,
    presentingViewController: self,
    highlightConfiguration: .withCustomRotation(angle: 10)
)

// 효과 없음
CircularMenuManager.shared.addLongPressMenu(
    to: myView,
    targetView: myView,
    items: items,
    presentingViewController: self,
    highlightConfiguration: .default
)
```

### 메뉴 외관

메뉴 뷰 컨트롤러를 커스터마이징하여 외관을 변경합니다:

```swift
CircularMenuManager.shared.addLongPressMenu(
    to: myView,
    targetView: myView,
    items: items,
    presentingViewController: self,
    customization: { menuVC in
        menuVC.buttonSize = 60           // 버튼 크기
        menuVC.menuRadius = 120          // 메뉴 반경
        menuVC.animationDuration = 0.4   // 애니메이션 시간
    }
)
```

### 전역 상수

앱 전체에서 일관된 스타일을 위해 전역 상수를 수정할 수 있습니다:

```swift
// 전역 상수 수정 (모든 메뉴에 적용)
CircularMenuConstants.Layout.buttonSize = 60
CircularMenuConstants.Layout.menuRadius = 120
CircularMenuConstants.Animation.duration = 0.4
```

### 커스텀 메뉴 아이템

`CircularMenuItemProtocol`을 준수하여 커스텀 메뉴 아이템을 만들 수 있습니다:

```swift
struct MyCustomMenuItem: CircularMenuItemProtocol {
    let name: String
    let image: UIImage?
    let backgroundColor: UIColor
    let action: (() -> Void)?

    // 커스텀 속성 추가
    let priority: Int
    let isDestructive: Bool
}
```

## 아키텍처

라이브러리는 다음 컴포넌트로 구성되어 있습니다:

- **Core**: 프로토콜 정의 및 핵심 유틸리티
  - `CircularMenuItemProtocol`: 메뉴 아이템 프로토콜
  - `ViewHighlightManager`: 뷰 하이라이트 효과 관리
  - `ViewHighlightEffect`: 시각 효과 설정

- **View**: UI 컴포넌트
  - `CircularMenuViewController`: 메인 메뉴 뷰 컨트롤러
  - `CircularMenuButton`: 개별 메뉴 버튼
  - `TapMenuViewController`: 탭 기반 메뉴 변형

- **ViewModel**: 비즈니스 로직 및 제스처 처리
  - `CircularMenuManager`: 메인 매니저 (싱글톤)
  - `CircularMenuGestureHandlers`: 제스처 인식기 핸들러

- **Model**: 데이터 모델 및 상수
  - `CircularMenuConstants`: 설정 상수

## 예제

CircularContextMenu의 다양한 기능을 보여주는 샘플 프로젝트를 확인하세요:

**[CircularContextMenu-Example](https://github.com/songmoro/CircularContextMenuExample)**

예제 프로젝트에는 다음이 포함되어 있습니다:
- 컬렉션 뷰와 원형 메뉴 통합
- 롱 프레스 및 탭 메뉴 데모
- 다양한 커스터마이징 예제
- 실제 사용 패턴

## 라이선스

CircularContextMenu는 MIT 라이선스 하에 제공됩니다. 자세한 내용은 LICENSE 파일을 참조하세요.

## 제작자

songmoro

## 기여

기여를 환영합니다! Pull Request를 자유롭게 제출해주세요.
