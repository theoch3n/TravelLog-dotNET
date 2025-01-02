
let map;
let currentPosition;
let selectRestaurant;
let markers = [];
let directionsService;
let directionsRenderers = [];
let itinerary = JSON.parse(localStorage.getItem('itinerary')) || [];

// 初始化地圖
function initMap() {
    map = new google.maps.Map(document.getElementById('map'), {
        center: { lat: 23.553118, lng: 121.0211024 },
        zoom: 7,//地圖尺寸
    });

    navigator.geolocation.getCurrentPosition(function (position) {
        currentPosition = {  //取得當前位置
            lat: position.coords.latitude,
            lng: position.coords.longitude,
        };
        map.setCenter(currentPosition);
        map.setZoom(16);//放大當前位置

        // 初始化 Autocomplete
        const autocomplete = new google.maps.places.Autocomplete(document.getElementById('search-input'), {
            type: ['restaurant'],
        });
        //搜尋框點選餐廳，自動呼叫船進去的function
        autocomplete.addListener('place_changed', function () {
            const place = autocomplete.getPlace();
            selectRestaurant = {
                location: place.geometry.location,
                placeId: place.place_id,
                name: place.name,
                address: place.formatted_address,
            };
            //設定marker要設定在地圖上
            const marker = new google.maps.Marker({
                position: selectRestaurant.location,
                map: map,//設定marker位置
            });
            markers.push(marker);
            map.setCenter(selectRestaurant.location);
        });

        renderItinerary();
    });
}

// 顯示行程列表
function renderItinerary() {
    const listElement = document.getElementById('itinerary-list');
    listElement.innerHTML = '';

    itinerary.forEach((place, index) => {
        listElement.innerHTML += `
                    <li class="list-group-item d-flex justify-content-between align-items-center" data-index="${index}">
                        <span>${place.name}</span>
                        <button class="btn-close remove"></button>
                    </li>
                `;

        // 在行程項目之間加入路程時間和距離的欄位
        if (index < itinerary.length - 1) {
            listElement.innerHTML += `
                        <li class="list-group-item text-center text-muted route-info" id="route-info-${index}">
                            計算中...
                        </li>
                    `;
        }
    });
}

// 新增行程
document.getElementById('add').addEventListener('click', function () {
    if (selectRestaurant) {
        itinerary.push(selectRestaurant);
        localStorage.setItem('itinerary', JSON.stringify(itinerary));
        renderItinerary();
        document.getElementById('search-input').value = '';//清空搜尋欄位

    }
});

// 移除行程
document.getElementById('itinerary-list').addEventListener('click', function (e) {
    if (e.target.classList.contains('remove')) {
        const index = Array.from(e.target.parentNode.parentNode.children).indexOf(e.target.parentNode);
        itinerary.splice(index, 1);
        localStorage.setItem('itinerary', JSON.stringify(itinerary));
        markers[index]?.setMap(null);
        markers.splice(index, 1);
        renderItinerary();
    }
});

// 規劃路線
document.getElementById('draw-route').addEventListener('click', function () {
    if (!directionsService) directionsService = new google.maps.DirectionsService();

    directionsRenderers.forEach(renderer => renderer.setMap(null)); // 清除舊的路線
    directionsRenderers = [];

    const colors = ['#FF0000', '#0000FF', '#00FF00', '#FFA500', '#800080']; // 路線顏色清單

    for (let i = 0; i < itinerary.length - 1; i++) {
        const origin = itinerary[i].location;
        const destination = itinerary[i + 1].location;

        const renderer = new google.maps.DirectionsRenderer({
            map: map,
            suppressMarkers: true,
            polylineOptions: {
                strokeColor: colors[i % colors.length], // 循環使用顏色清單
                strokeWeight: 6,
            },
        });
        directionsRenderers.push(renderer);

        directionsService.route({
            origin: origin,
            destination: destination,
            travelMode: "DRIVING", // 預設開車模式
        }, function (response, status) {
            if (status === "OK") {
                renderer.setDirections(response);

                // 顯示路程距離與時間
                const leg = response.routes[0].legs[0];
                document.getElementById(`route-info-${i}`).textContent =
                    `距離: ${leg.distance.text}, 預估時間: ${leg.duration.text}`;
            } else {
                alert("無法規劃路線：" + status);
            }
        });
    }

    markers.forEach(marker => marker.setMap(null)); // 清除舊的地標
    itinerary.forEach((place, index) => {
        const marker = new google.maps.Marker({
            position: place.location,
            label: `${index + 1}`,
            map: map,
        });
        markers.push(marker);
    });
});

// 啟用拖放功能
new Sortable(document.getElementById('itinerary-list'), {
    animation: 150,
    onEnd: function (event) {
        const oldIndex = event.oldIndex;
        const newIndex = event.newIndex;
        const movedItem = itinerary.splice(oldIndex, 1)[0];
        itinerary.splice(newIndex, 0, movedItem);
        localStorage.setItem('itinerary', JSON.stringify(itinerary));
        renderItinerary();
    },
});

renderItinerary();

