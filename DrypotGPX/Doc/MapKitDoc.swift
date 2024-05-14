//
//  MapKitDoc.swift
//  DrypotGPX
//
//  Created by Kyuhyun Park on 5/13/24.
//


/*
 
 Enabling Maps capability in Xcode
 https://developer.apple.com/documentation/mapkit/mapkit_for_appkit_and_uikit/enabling_maps_capability_in_xcode

 Maps Capability 추가하는 것은 iOS 에서만 필요하다고 한다.
 macOS 에서는 필요없다고.
 https://developer.apple.com/documentation/xcode/configuring-maps-support
 
 *
 
 MapCameraPosition 에 .userLocation 을 사용하려면 Location 을 켜야 한다.
 
 Project -> Targets -> Signing & Capabilities
 -> App Sanbox -> App Data -> Location
 
 *
 
 네트웍도 켜야 지도 오류가 안 나는 것 같다.
 
 Project -> Targets -> Signing & Capabilities
 -> App Sanbox -> Network -> Outgoing Connections (Client)
 

 */
