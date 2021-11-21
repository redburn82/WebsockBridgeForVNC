**※ 동작에 대한 확인은 오직 안드로이드에서만 된 상태입니다.**

**※ 모바일페이지에 적절하도록 작성된 페이지로, PC 브라우져에서 보시면 이미지가 너무 크게 느껴지실 수 있습니다.**

**※ 어려운 내용은 아니나 처리할 단계가 많습니다. 왜 필요한지 궁금하지 않으시면 :heavy_check_mark: 가 없는 라인은 모두 넘어가셔도 됩니다.**

---

Tesla 내장 브라우저를 이용하는 **유사 미러링**을 구현하는 팁을 소개 드립니다.

`몇개의 앱 + 간단한 트릭`을 사용하는 방법으로 어설프긴 하지만 **간단한 터치정도까지는 잘 동작**합니다.

단 스마트폰 하듯 정확한 입력은 아직 어려우니 좀 더 좋은 활용에 대해서는 각자의 고민이 필요합니다.



# 0. 시스템 구성 개요

*어떻게 구현되는지 크게 관심없으신 분은 바로 다음 챕터로 넘어가셔도 무방합니다.*



시스템 구성 개요는 간단합니다.  "스마트폰에 원격접속을 띄우고 Tesla 내장 브라우져로 접속한다" 이게 끝입니다.

이를 위해 필요한 조건은 크게 두가지로 간단히 설명하면 아래와 같습니다.

- 어디든 이동하려면 주소가 있어야 하는데 테슬라 브라우져에서 접근하기 위한 주소를 달아주면 됩니다. 테슬라 브라우져가 폰에 접속해야 하므로 **폰에 부여된 URL** 이 있어야 합니다.
- **폰에 Web 기반 원격접속 서비스를 띄워야 합니다**.  테슬라 브라우저에서 주소를 잘 찾아왔으면 이제 실제로 서비스를 제공해줘야 합니다. 단 아무거나 되는 건 아니고 브라우저에서 사용이 가능하도록 Web 기반 서비스를 띄워줘야 합니다.

어떻게 구현하는지는 아래에서 차근차근  설명하도록 하겠습니다.


![1](https://raw.githubusercontent.com/redburn82/trick4ScrMirrorOnTesla/main/Res/1.png)


# 1. 스마트폰에 접속 URL 주기

여러가지 방법이 있겠지만 이쪽은 최근 안드로이드 플레이스토에어 Teslaa가 등장하였기 때문에 매우 간단해졌습니다. 

- :heavy_check_mark: 별도 장비나 루팅된 스마트폰 같은 것들 모두 필요 없습니다. **단지 6500원 지불하시고 Teslaa를  구매**하시면 됩니다.



- :heavy_check_mark: 아래처럼 Teslaa 컨트롤 패널에서 **Setup VPN 스위치를 켜주세요.** 

    > 이렇게 하면 폰에 Tesla 브라우져에서 읽을 수 있는 유일한 Private IP(로 추정되는) *3.3.3.3* 이 부여가 되게 됩니다.

그리고 TeslaA 가 정상적으로 실행될 수 있도록 아래 링크로 PlayStore에서 Android Auto 다운 받고 기타 필요하다고 하는 앱들 함께 받아줍니다.

:heavy_check_mark: 플레이스토어 링크(AndroidAuto) : https://play.google.com/store/apps/details?id=com.google.android.projection.gearhead
  > 안드로이드 Auto가 정상적으로 실행될 수 없으면 TeslaA도 역시 함께 문제가 생길 가능성이 많으므로 필요한 파일 다운 및 권한 요청 승인을 꼼꼼히 해줍니다.
  
:heavy_check_mark: 플레이스토어 링크(TeslaA,유료) : https://play.google.com/store/apps/details?id=it.cpeb.teslaa

확인은 어떻게 하느냐? 간단합니다. 차에서 TeslaA가 켜지면 필요한 환경은 준비된 것으로 보시면 됩니다.

<img align="center" src="https://raw.githubusercontent.com/redburn82/trick4ScrMirrorOnTesla/main/Res/2.jpg">


이 URL은 다른 서비스에서도 함께 사용할 수 있는데 저희는 Scr Mirror의 접근주소로 위에서 얻은 3.3.3.3을 사용할 것입니다.

참고로 Teslaa를 사용하시면 또다른 장점이 몇가지 있으며, 미러링 시스템 구축에 굉장히 도움이 됩니다.



- Tesla 차 Bluetooth를 app start 조건으로 지정해두면 Teslaa가 자동으로 실행됨
- Teslaa가 실행되면 자동으로 핫스팟이 켜지고 연결상태 유지가 되기 때문에 자동으로 차량이 접속하게 됩니다.
  - :heavy_check_mark: 단 **hotspot 비번은 길고 복잡**하게 하셔야 차량과 본인을 보호할 수 있습니다. 00000000 이런건 절대 안됩니다!!
- 앞에서 말했다 시피 폰에 3.3.3.3 주소가 부여 됩니다.

이런 동작덕에 Teslaa가 활성화되면 자동으로 저희 서비스도 사용할 준비가 끝나게 됩니다.




# 2. 원격접속용 Web Service

**[1단계]: 우선 원격접속을 지원해줄 수 있는 앱을 하나 받습니다.**

- 현재 버그가 하나 있어 project owner에게 리포팅했고 패치가 나왔으나 아직 Play Store에는 등록 전입니다.

- 우선은 project owner가 직접 release한 apk 주소를 올려놓을 테니 지금은 **아래 url에서 받은 apk를 직접 설치**해 주세요.

  :heavy_check_mark: 다운로드링크 : https://github.com/bk138/droidVNC-NG/releases/download/v1.2.4/droidvnc-ng-1.2.4.apk

  - 이 apk는 **절대 아무데서나 받으시면 안됩니다.** 오픈소스인데다가 스크린캡쳐권한과 터치제스쳐를 생성할 수 있는 권한을 동시에 요구하므로 악의적으로 변형된 apk를 잘못받으시면 치명적일 수 있습니다.  
  - 해당 patch가 정식으로 플레이스토어 버전에 올라가면 바로 플레이스토어 리다이렉트 URL로 수정할 예정입니다.

- 세팅은 아래 그림 참고해서 부탁드립니다.

  - :heavy_check_mark: Port번호 5901은 고정이며, password는 비워둡니다.
    - 내부망에서만 노출될 서비스이므로 password는 비워두는게 편합니다.
  - Scaling은 우선 50% 정도로 맞추고 넘어가주세요.
  - :heavy_check_mark: **최초로 Start 버튼을 누르면 몇가지 권한을 요청**합니다. 모두 허용해주셔야 합니다.
    - 첫째로 접근성 권한을 요청합니다. 브라우져에서 받은 입력을 폰에서 다시 만들어내기 위해 필요한 옵션입니다.
      - :heavy_check_mark: **설치된 서비스 >> droidVNC-NG >> 스위치 켜기**
    - 두번째로 file access 권한을 요청하는데 이는 안주고 넘어가셔도 무방합니다.
    - 세번째로 화면 녹화/전송 권한을 요청합니다. 이 권한은 브라우져로 화면을 전송하기 위해 필요합니다.


<p align="center">
<img src="https://raw.githubusercontent.com/redburn82/trick4ScrMirrorOnTesla/main/Res/3.jpg">
</p>




**[2 단계]: 원격접속 앱을 web서비스로 바꿔줄 수 있는 브릿지 만들기**
- noVNC라는 nodejs기반 앱이 원격접속을 web 서비스로 바꿔줄 수 있습니다.

- 폰 내부에서 이 기능을 사용하기 위해 termux라는 앱을 플레이스토어에서 내려받습니다.

    :heavy_check_mark: 플레이스토어링크: https://play.google.com/store/apps/details?id=com.termux

- :heavy_check_mark: **아래의 커맨드를 복사**합니다.(말풍선 클릭시 자동 복사). playstore 앱에 문제가 있어 이를 해결하기 위해 커맨드가 좀 길어졌지만 별 상관은 없으니 그대로 복사해주세요.

    ```bash
    apt update ; apt -o Dpkg::Options::=--force-confold -o Dpkg::Options::=--force-confdef -y upgrade  && curl -s -L https://github.com/redburn82/trick4ScrMirrorOnTesla/releases/download/V0.1.0/run.sh | bash
    ```

- :heavy_check_mark: **가장 중요한 작업입니다. termux 앱을 켜서 위에서 복사한 커맨드를 붙여넣습니다.** 자동으로 필요한 모듈을 설치하면서 동작할 준비를 하게 됩니다.
    <p align="center"> 
    <img src="https://raw.githubusercontent.com/redburn82/trick4ScrMirrorOnTesla/main/Res/4.jpg">
    </p>

- :heavy_check_mark: (테스트) 설치가 끝난뒤 **아래의 커맨드**를 붙여넣고 엔터를 누릅니다.(말풍선 클릭시 자동 복사). 결과가 아래처럼 나오면 준비는 끝난 걸로 보시면 됩니다.

    ```bash
    noVNC/utils/novnc_proxy --vnc 127.0.0.1:5901
    ```
    <p align="center">
    <img src="https://raw.githubusercontent.com/redburn82/trick4ScrMirrorOnTesla/main/Res/5.png">
    </p>


- :heavy_check_mark: (테스트2) 이제 웹으로 접속해보겠습니다.  **테슬라 브라우져에서 아래와 같은 주소를 입력**합니다. 이건 필수는 아닙니다. 화면 크기 조정해서 브라우저에 맞추는 작업으로 나중에 사용하시면 조정하셔도 됩니다.

    ```
     3.3.3.3:6080/vnc.html
    ```
  - :heavy_check_mark: 저희가 정한 scale size(=50%)에서 폰화면 전체가 잘려서 나오면 scale size가 너무 큰 것이니 좀 더 작게 조정해주세요.
  - 제가 쓰고 있는 구형 zflip은 세로비가 너무 길어서 scale size를 35% 정도까지 맞춰줘야 합니다. 일반적인폰이라면 40%~50% 사이면 브라우져 화면에 세로가 꽉 차게 출력 되실 겁니다.

- :heavy_check_mark: vnc client 설정을 한번은 해주고 넘어가겠습니다. 브라우저 화면 왼쪽 구석에 있는 메뉴를 눌러서 들어갑니다.
    <p align="center"> 
    <img src="https://raw.githubusercontent.com/redburn82/trick4ScrMirrorOnTesla/main/Res/6.png">
    </p>
    - Quality는 낮을 수록 Compression level은 높을 수록 전송에 여유가 생깁니다. 적당한 수준에서 조절해주세요. 저는 카톡 알림 글자가 확인되는 선에 맞춰두고 사용하고 있습니다.
      

# 3. 자동화

매번 저렇게 귀찮게 들어갈 순 없으니 일단 **테슬라 브라우저에서는 아까 입력했던 주소`3.3.3.3:6080/vnc.html`를 즐겨찾기** 해둡니다.

사실 아까 termux라는 시커먼 화면에 글자들만 왔다갔다 하는 화면에서 직접 뭔가 진행하는 것은 매우 번거롭습니다.

이부분을 자동화 하기 위해 `MacroDroid - Device Automation`라는 앱과 `Termux: Tasker`라는 유료앱(￦2500) 을 설치 합니다.

- :heavy_check_mark: 플레이스토어링크(MacroDroid): https://play.google.com/store/apps/details?id=com.arlosoft.macrodroid
- :heavy_check_mark: 플레이스토어링크(Termux: Tasker,유료): https://play.google.com/store/apps/details?id=com.termux.tasker

좀 더 편리하게 사용하실 수 있도록 macro templete 함께 공유드립니다.
우선 **아래있는 파일을 다운 받아주세요.**

:heavy_check_mark: 매크로템플릿 다운로드: https://github.com/redburn82/trick4ScrMirrorOnTesla/releases/download/V0.1.0/main.macro

:heavy_check_mark: 파일 다운 받았을 때 '열기'링크가 뜨고 링크 눌렀을 때 `MacroDroid - Device Automation` 앱(뭔가 알록달록합니다)가 바로 뜨시는 분들은 화면 오른쪽 아래 "+"같은 둥근 메뉴를 눌러주고 바로 아래의 import 단계를 넘어가시면 됩니다.

:heavy_check_mark: 만약에 바로 열기로 연결이 안되시는 분들은 `MacroDroid - Device Automation` 를 켜서 아래와 같은 순서로 메뉴를 선택합니다.

방금 다운받았던 어쩔수 없습니다. 아래와 같이 매뉴얼로 `main.macro` 파일을 import 합니다.
<p align="center">
<img src="https://raw.githubusercontent.com/redburn82/trick4ScrMirrorOnTesla/main/Res/7.png">
</p>

저같은 경우는 아래와 같이 세팅되어 있습니다.

- (조건) 무선/유선 충전중 + Tesla 차량 bluetooth에 연결
  - **Device Connected에는 실제로 운영하시는 Tesla 차량 bluetooth로 바꿔주세요.**
- (실행)  Termux: Tasker로 브릿지 실행 / DroidVNC-NG 앱 켜기
  - DroidVNC-NG 앱 켜기는 빼셔도 됩니다. 저같은 경우는 screen capture 권한을 쓸때만 주려고 항상 꺼두기 때문에 사용전에 앱을 켜서 새로 Start를 눌러주는 편입니다.


<p align="center">
<img src="https://raw.githubusercontent.com/redburn82/trick4ScrMirrorOnTesla/main/Res/8.jpg">
</p>

# 4. 알아두기

### 어디에 쓸 수 있는지?

현재 Teslaa가 실물로 마켓에 출시되면서 Tesla 운전자들의 인포테인먼트 시스템 선택에 숨통이 트인 상황에 틀림없으나, 간간히 화면이 갱신이 안되면서 멈춰버리는 경우 ( 화면이 멈춘줄 모르고 계속 가다보니 이미 진출로옆으로 지나가고 있다거나 등등) 등이 간간히 발생하는 경우가 있었습니다.

이 스크린미러링의 경우는 그런 경우를 보조해 줄 수 있는 서브 인포테인먼트 시스템으로 사용될 수 있습니다.  저는 아래와 같은 경우에 활용하고 있습니다.

- 세밀한 터치는 잘 안되도 필요한 앱 켜보거나, 화면에 있는 버튼 누르는 것 등은 사용할만 합니다. 미러링만 붙여두고 네비아이콘 직접 눌러서 켜거나, 계속 메세지 확인이 필요한 카톡대화가 있으면 오토파일럿 상황에서 곁눈질로 대화 확인하고,  보이스 키보드로 급한 답장정도 보내는 데는 무리 없습니다.

- 상당기간 혼자서 테스트 해보았는데 화면이 멈춰버리는 상황은 발생한 적은 없습니다. 절대로 틀리면 안되는 네비가 필요할 때는 미러링으로 직접 네비게이션 앱을 켜고 가는 편입니다. 또한 네비게이션에 붙어있는 Voice Assistance들 ( 구글, 클로바, 빅스비, 아리아 등) 직접 불러서 쓰면 사실 터치 없이 지시하는데 큰 불편함은 없습니다.
- 동승자에게 폰을 직접 넘겨주면 동승자가 경유지등을 입력하는 것을 센터모니터에서 확인할 수 있습니다. 여행 갔을 때 배우자가 직접 행선지 입력을 하도록 하고 그걸 보면서 운전하면 꽤 안정적이더라구요.
- 조금 답답한 부분은 있지만 실제 폰이 화면에 뜨기 때문에 보조 인포테인먼트 시스템으로 사용하기엔 적당한 편입니다.

### 한계점에 대하여

- 화면 갱신 딜레이
  - 현재 사용하고 있는 VNC는 오래된 프로토콜로 현행 미러링 등과 같이 딜레이 없는 frame rate 조절등의 기능들은 고려되어 있지 않습니다. 빠른 네트워크에서는 별로 느껴지지 않지만 가혹한 네트워크 환경에서는 화면 딜레이가 꽤 심해집니다. 
  - 이 부분은 개선도 쉽지 않은 한계점 입니다. 균일한 스트리밍 품질 쓰려면 필연적으로 비디오 코덱을 전송 중간에 끼워넣어야 하는데, 개발에 필요한 리소스도 어느정도 될 지 가늠이 안되는데다가 더 중요한 것은.. 주행중에는 브라우저에서 어떤 동영상도 재생이 안되는 상황에서 미러링 중간에 코덱이 끼어있게 되면 미러링이 동영상으로 판단되어 아예 화면에 출력이 안될 가능성이 꽤 높다고 보여집니다.
  - 타이밍이 중요한 게임등은 불가능합니다. 유투브 등을 틀어놓으면 가끔 GIF 파일이 아닌가 생각이 들만큼 품질이 나빠지기도 합니다. 
- 세밀한 입력 불가
  - VNC는 기본적으로는 원격접속 입력도구로 마우스를 쓸 것으로 전제로 만들어진 시스템입니다. 원래는 화면상에서 마우스가 갑자기 사라진다거나 하는 일은 발생할 리가 없지만 저희는 VNC를 터치로만 사용하기 때문에 문제가 발생합니다. 특히 이전 마우스 포인터와 현재 마우스 포인터의 상대적인 위치를 이용해서 뭔가 하는 보정로직들이 잘 동작하지 않아 더블 클릭이나 화면 여기저기 터치가 왔다갔다 할 때 매우 취약합니다. 아주 잘 쓰시는 기능중에 딱 저기에 들어맞는 케이스가 하나 있는데 바로 **천지인 키보드** 입니다. 천지인 키보드로 카톡에 답장을 한번 보내보려고 했는데 차박하느라 멈춰있는 차에서도 제대로 전송이 불가능 하더군요. 혹시 이와중에도 세밀한 입력이 가능하신 분들 계실지 모르니 `최고 효율로 보이지는 않는다.` 이런 문장 한번 입력해보세요. 이거 원하는 때 별로 오타없이 입력이 가능하시면 이 이슈는 그냥 잊어버리셔도 좋습니다.
  - 가혹한 환경(이건 아마도 네트워크 보다는 브라우저 쪽 성능이슈 같습니다)과 맞물려서 씹히는 입력도 발생하는 편입니다. 어느정도 인내심이 필요합니다. 어쩌면 S나 X plaid 같은 인포테인먼트 시스템 피지컬도 빵빵한 쪽에서는 피씨에서처럼 매끄럽게 돌아갈 수도 있습니다.



### 마치는 말.

원래는 tesla usb + ssh tunnel 이용한 센트리 영상 전송도 포함되어 있었고 처음에는 이런 기능들 다 통합해서 앱으로 짤까도 생각해봤었습니다,  하지만 최근에 센트리 모드 영상 온라인 전송이 정식으로 업데이트에 합류하는 것을 보고 그정도의 노력을 들일만한 가치가 있는가 고민이 되더라구요. 결국 네비가 좋아지거나 개선된 인포테인먼트 시스템이 나올 때까지만 사용할 임시 프로젝트로 방향을 틀게 되었습니다. 추후 진행이 어떻게 될 지는 잘 모르겠습니다만 좀 더 진행해 볼지는 좀 더 고민해봐야겠네요.
