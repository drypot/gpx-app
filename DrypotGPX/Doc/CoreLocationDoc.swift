//
//  CoreLocationDoc.swift
//  DrypotGPX
//
//  Created by drypot on 2024-04-14.
//

//
// 장비의 현재 Location 읽으려면 프로젝트 세팅을 해줘야 한다.
// Project -> Targets -> Signing & Capabilities -> App Sanbox -> App Data -> Location 체크
//
// MapKit 으로 지도 보려면 추가 세팅.
// Project -> Targets -> Signing & Capabilities -> App Sanbox -> Network -> Outgoing Connections (Client) 체크
//

// https://developer.apple.com/documentation/corelocation/cllocationmanager/1620548-requestlocation
// requestLocation 은 로케이션을 한번만 받고 서비스를 죽인다.
// 반복 호출한다고 델리게이트가 반복 반응하지 않는다.
//
// 하지만 requestLocation 한번 호출에 델리게이트가 3번 연달아 호출될 때도 있었고,
// 두번째 불렀을 때도 호출될 때도 있고,
// 반응이 없을 때도 있다,
//
// 장비 Location 읽는 기능은 가능하면 넣지 말자.
// 생각해 보면 별 필요없다.
//
