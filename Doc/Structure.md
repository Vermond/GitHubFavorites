# Structure

## 전체 구조

Controller : 주요 데이터 컨트롤러
 - NetworkController : 네트워크 통신 담당
 - StorageController : CoreData 래핑 클래스

Model : 데이터 구조
 - GitHubUserModel : 깃헙 API의 사용자 검색 결과와 매칭되는 데이터 포맷

View : 뷰 클래스 및 아이템
 - Item : 뷰 아이템들
   - FavoriteButton : 즐겨찾기 버튼
   - SearchTextField : 커스텀 텍스트 필드 (검색창용)
   - SimpleUserCell : 사용자 정보를 표시하는 테이블의 커스텀 셀
 - ViewController : 뷰 컨트롤러
   - FavoriteSearchVC : 로컬에 저장된 즐겨찾기 목록을 보여주는 뷰 컨트롤러
   - UserSearchVC : GitHub API에서 검색한 결과 목록을 보여주는 뷰 컨트롤러


## 데이터 흐름
앱 실행 - UserSearchVC 로드 - 텍스트필드에 입력 후 다음 조건 충족시 검색 수행 - 결과를 테이블 뷰에 출력
       ㄴ FavoriteSearchVC 로드 (전체 즐겨찾기 목록 출력) - 텍스트 필드에 입력시 다음 조건 충족하면 검색 수행 - 결과를 테이블 뷰에 출력
조건
 - 3초간 입력이 없을 때
 - 엔터 입력시
 - 텍스트 필드 밖을 클릭하여 포커스가 벗어났을 때

 
 ## 사용 라이브러리
 - Kingfisher
   - 이미지 로딩 및 캐시 저장 등을 수행하는 라이브러리
   - 사용자 정보 중 프로필 이미지를 출력하는데 사용



