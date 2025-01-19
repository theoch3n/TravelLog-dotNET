
let map;
let currentPosition;
let selectRestaurant;
let markers = [];
let directionsService;
let directionsRenderers = [];
let itinerary = JSON.parse(localStorage.getItem('itinerary')) || [];
let infoWindow;
const placesList = []; // 存放所有的地點資訊
var baseAddress = "https://localhost:7030";


//// 初始化地圖

//function initMap() {
//    map = new google.maps.Map(document.getElementById('map'), {
//        center: { lat: 23.553118, lng: 121.0211024 },
//        zoom: 7,//地圖尺寸
//    });

//    navigator.geolocation.getCurrentPosition(function (position) {
//        currentPosition = {  //取得當前位置
//            lat: position.coords.latitude,
//            lng: position.coords.longitude,
//        };
//        map.setCenter(currentPosition);
//        map.setZoom(16);//放大當前位置

//        // 初始化 Autocomplete
//        const autocomplete = new google.maps.places.Autocomplete(document.getElementById('search-input'), {
//            type: ['restaurant'],
//        });
//        //搜尋框點選餐廳，自動呼叫船進去的function
//        autocomplete.addListener('place_changed', function () {
//            const place = autocomplete.getPlace();
//            selectRestaurant = {
//                location: place.geometry.location,
//                placeId: place.place_id,
//                name: place.name,
//                address: place.formatted_address,
//                lat: place.geometry.location.lat(),
//                lng: place.geometry.location.lng(),
//                phoneNumber: place.phoneNumber,
//                rating: place.rating

//            };
//            //console.log(selectRestaurant);
//            //console.log(place.geometry.location.lat());
//            //console.log(place.geometry.location.lng());
//            console.log(selectRestaurant.lat);
//            console.log(selectRestaurant.lng);



//            //將選取經緯度存成變數
//            var selectposition = {
//                lat: selectRestaurant.lat,
//                lng: selectRestaurant.lng,
//            };
//            //設定marker要設定在地圖上
//            const marker = new google.maps.Marker({
//                position: selectposition,
//                map: map,//設定marker位置
//            });
//            markers.push(marker);
//            map.setCenter(selectposition);

//            //設定資訊框
//            if (!infoWindow) {//將對話匡初始化
//                infoWindow = new google.maps.InfoWindow();
//            }

//            infoWindow.setContent(//設定infoWindow裡的內容
//                `
//                                <h3>${selectRestaurant.name}</h3>
//                                <div>地址：${selectRestaurant.address}</div>
//                                <div>電話：${selectRestaurant.phoneNumber}</div>
//                                <div>評分：${selectRestaurant.rating}</div>
//                                <div>
//                                     <button  class="btn btn-primary mt-2" id="add">
//                                            加入行程
//                                     </button>
//                                </div>
//                                `
//            );
//            infoWindow.open(map, marker)//打開資訊筐指定要畫在哪個地圖跟哪個點
//            renderItinerary();
//        });

//    });
//}




//初始化地圖
function initMap() {
    map = new google.maps.Map(document.getElementById('map'), {
        center: { lat: 23.553118, lng: 121.0211024 },
        zoom: 7, // 地圖尺寸
    });
    //renderItinerary(itinerary);
    navigator.geolocation.getCurrentPosition(function (position) {
        const currentPosition = { // 取得當前位置
            lat: position.coords.latitude,
            lng: position.coords.longitude,
        };
        map.setCenter(currentPosition);
        map.setZoom(16); // 放大當前位置

        // 初始化 Autocomplete
        const autocomplete = new google.maps.places.Autocomplete(document.getElementById('search-input'), {
            type: ['restaurant'],
        });

        // 監聽搜尋事件
        autocomplete.addListener('place_changed', function () {
            const place = autocomplete.getPlace();

            // 檢查是否有地點資料
            if (!place.geometry || !place.geometry.location) {
                console.error("搜尋結果無法取得地點資訊");
                return;
            }

            // 建立地點物件
            const selectRestaurant = {
                location: place.geometry.location,
                placeId: place.place_id,
                name: place.name,
                address: place.formatted_address,
                lat: place.geometry.location.lat(),
                lng: place.geometry.location.lng(),
                phoneNumber: place.formatted_phone_number || "無資料",
                rating: place.rating || "無評分",
            };

            // 將新地點加入陣列
            placesList.push(selectRestaurant);

            // 建立 marker
            const marker = new google.maps.Marker({
                position: selectRestaurant.location,
                map: map,
            });
            markers.push(marker);

            // 綁定 marker 點擊事件
            marker.addListener("click", function () {
                // 點擊時顯示對應地點的資訊
                if (!infoWindow) {
                    infoWindow = new google.maps.InfoWindow();
                }

                infoWindow.setContent(`
                    <h3>${selectRestaurant.name}</h3>
                    <div>地址：${selectRestaurant.address}</div>
                    <div>電話：${selectRestaurant.phoneNumber}</div>
                    <div>評分：${selectRestaurant.rating}</div>
                    <div>
                        <button class="btn btn-primary mt-2" id="add-to-itinerary">
                            加入行程
                        </button>
                    </div>
                `);

                infoWindow.open(map, marker);
                document.getElementById('search-input').value = '';//清空搜尋欄位
                
                console.log(selectRestaurant);
                // 監聽windowfo綁定加入行程按鈕
                google.maps.event.addListenerOnce(infoWindow, "domready", () => {
                    const addButton = document.getElementById("add-to-itinerary");
                    addButton.addEventListener("click", function () {
                        itinerary.push(selectRestaurant);
                        localStorage.setItem('itinerary', JSON.stringify(itinerary));
                        renderItinerary(itinerary);//重新渲染行程列表
                        

                        //// 新增行程進資料庫place
                        if (selectRestaurant) {

                            fetch(`${baseAddress}/api/Places`, {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/json',
                                },
                                body: JSON.stringify({

                                    date: 1,
                                    scheduleId: 1,
                                    name: selectRestaurant.name,    // 使用 selectRestaurant 的資料
                                    address: selectRestaurant.address,
                                    latitude: selectRestaurant.lat,  //來自 selectRestaurant 的緯度
                                    longitude: selectRestaurant.lng//來自 selectRestaurant 的經度
                                }),
                            })
                                .then(response => {
                                    if (!response.ok) {
                                        throw new Error(`HTTP error! status: ${response.status}`);
                                    }
                                    return response.json();
                                })
                                .then(data => {
                                    console.log('地點已成功儲存：', data);

                                    itinerary.push(selectRestaurant); // 更新前端行程陣列
                                    renderItinerary(itinerary);
                                    document.getElementById('search-input').value = ''; // 清空搜尋欄位
                                })
                                .catch(error => {
                                    console.error('儲存地點時發生錯誤：', error);
                                    alert('儲存地點時發生錯誤，請稍後再試。'); // 顯示錯誤提示
                                });
                        } else {
                            alert('請選擇一個地點！'); // 如果沒有選擇地點，提示用戶
                            renderItinerary(itinerary);
                        }
                    });
                });


            });

            // 設定地圖中心到新地點
            map.setCenter(selectRestaurant.location);
        });
    });
}





// 新增行程
document.getElementById('add').addEventListener('click', function () {
    if (selectRestaurant) {
        itinerary.push(selectRestaurant);
        localStorage.setItem('itinerary', JSON.stringify(itinerary));
        renderItinerary(itinerary);//重新渲染行程列表
        document.getElementById('search-input').value = '';//清空搜尋欄位

    }
});




// 顯示行程列表
//function renderItinerary() {
//    const listElement = document.getElementById('itinerary-list');
//    listElement.innerHTML = '';

//    itinerary.forEach((place, index) => {
//        listElement.innerHTML += `
//                    <li class="list-group-item d-flex justify-content-between align-items-center" data-index="${index}">
//                        <span>${place.name}</span>
//                        <button class="btn-close remove"></button>
//                    </li>
//                `;

//        // 在行程項目之間加入路程時間和距離的欄位
//        if (index < itinerary.length - 1) {
//            listElement.innerHTML += `
//                        <li class="list-group-item text-center text-muted route-info" id="route-info-${index}">
//                            計算中...
//                        </li>
//                    `;
//        }
//    });
//}



// 顯示行程列表從資料庫
function renderItinerary(itinerary) {
    const listElement = document.getElementById('itinerary-list');
    listElement.innerHTML = '';  // 清空現有的列表

    // 確保 itinerary 不是空的
    if (itinerary.length === 0) {
        listElement.innerHTML = '<li>沒有地點可顯示</li>';
        return;
    }

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













// 移除行程
document.getElementById('itinerary-list').addEventListener('click', function (e) {
    if (e.target.classList.contains('remove')) {
        const index = Array.from(e.target.parentNode.parentNode.children).indexOf(e.target.parentNode);
        itinerary.splice(index, 1);
        localStorage.setItem('itinerary', JSON.stringify(itinerary));
        markers[index]?.setMap(null);
        markers.splice(index, 1);
        renderItinerary(itinerary);
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
        renderItinerary(itinerary);
    },
});


// 呼叫 API 取得所有地點
//fetch(`${baseAddress}/api/Places`, {
//    method: 'GET',
//    headers: {
//        'Content-Type': 'application/json',
//    },
//})
//    .then(response => {
//        if (!response.ok) {
//            throw new Error('Network response was not ok');
//        }
//        return response.json();
//    })
//    .then(data => {
//        console.log(data);  // 這裡的 data 會是地點資料的陣列
//        // renderPlaces(data);  // 假設你有一個函式用來顯示這些地點
//    })
//    .catch(error => {
//        console.error('Error fetching places:', error);  // 處理錯誤
//    });




// 呼叫 API 取得所有地點
fetch(`${baseAddress}/api/Places`, {
    method: 'GET',
    headers: {
        'Content-Type': 'application/json',
    },
})
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.json();
    })
    .then(data => {
        console.log(data);  // 查看資料
        renderItinerary(data);  // 將資料傳遞給 renderItinerary
    })
    .catch(error => {
        console.error('Error fetching places:', error);  // 處理錯誤
    });




// 新增行程進資料庫place
document.getElementById('add').addEventListener('click', function () {
    if (selectRestaurant) {

        fetch(`${baseAddress}/api/Places`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({

                date: 1,
                scheduleId: 1,
                name: selectRestaurant.name,    // 使用 selectRestaurant 的資料
                address: selectRestaurant.address,
                latitude: selectRestaurant.lat,  //來自 selectRestaurant 的緯度
                longitude: selectRestaurant.lng//來自 selectRestaurant 的經度
            }),
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }
                return response.json();
            })
            .then(data => {
                console.log('地點已成功儲存：', data);

                itinerary.push(selectRestaurant); // 更新前端行程陣列
                
                document.getElementById('search-input').value = ''; // 清空搜尋欄位
            })
            .catch(error => {
                console.error('儲存地點時發生錯誤：', error);
                alert('儲存地點時發生錯誤，請稍後再試。'); // 顯示錯誤提示
               
            });
    } else {
        alert('請選擇一個地點！'); // 如果沒有選擇地點，提示用戶
        renderItinerary(itinerary);
    }
});




renderItinerary(itinerary);

