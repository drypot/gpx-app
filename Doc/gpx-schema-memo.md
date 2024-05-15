# GPX Schema

    <gpx creator="www.plotaroute.com" version="1.1" ...>
        <metadata> // 생략가능, 1 개만
            <!-- elements must appear in this order -->
            <name>FINISH</name>
            <desc>FINISH</desc>
            <author>...</author>
            <copyright>...</copyright>
            <link>...</link>
            <time>...</time>
            <keywords>...</keywords>
            <bounds>...</...>

        <wpt lat="latitudeType, 필수" lon="longitudeType, 필수"> // Waypoint, 여럿 가능, 
            <!-- Position info -->
            <ele> decimal </ele>
            <time> dateTime </...>
            <magvar> degrees </...>
            <geoidheight> ...

            <!-- Description info -->
            <name> string </...>
            <cmt> string </...> // GPS 에 전달된다.
            <desc> string> </...> // 유저를 위한 추가 정보, GPS 에 전달되지 않는다.
            <src> string </...> // 소스 장비
            <link> link </...>
            <sym> string </...> // Text of GPS symbol name
            <type> string </...> // 웨이 포인트 타입.

            <!-- Accuracy info -->
            <fix> fix </...>
            <sat> int </...> // 사용된 위성 수;
            <hdop> decimal </...> // Horizontal dilution of precision.
            <vdop> decimal </...> // Vertical dilution of precision.
            <pdop> decimal </...> // Position dilution of precision.
            ageofdgpsdata
            dgpsid

            extensions

        <rte>  // Route, 여럿 가능

        <trk> // Track 여럿 가능
            <name> string </...> // 트랙 이름
            <cmt> string </...>
            <desc> string> </...>
            <src> string </...>
            <link> link </...>
            <number> int </...> // 트랙 번호
            <type> string </...>

            <extensions> ... </...>

            <trkseg> // 여러개 가능, GPS 가 중간에 꺼지고 그러면 세그먼트가 여러개 생성될 수 있다.
                <trkpt> // Waypoint Type
                
            
        <extensions> // 생략가능, 1개만
