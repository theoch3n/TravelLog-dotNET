
let map;
let currentPosition;
let selectRestaurant;
let markers = [];
let directionsService;
let directionsRenderers = [];
//let itinerary = JSON.parse(localStorage.getItem('itinerary')) || [];
let infoWindow;
const placesList = []; // 存放所有的地點資訊
var baseAddress = "https://localhost:7030";
let service; // TextSearch 使用的服務



//呼叫地圖api
function loadGoogleMapsAPI() {
    const script = document.createElement('script');
    script.src = "https://maps.googleapis.com/maps/api/js?key=AIzaSyA0mSwZn2Mgu42RjWRxivjrSC3s84nINa0&libraries=places&callback=initMap&region=TW&language=zh-TW";
    script.async = true;
    script.defer = true;

    script.onerror = function () {
        console.error('Google Maps API 載入失敗，請檢查金鑰是否正確或網路是否正常。');
    };

    document.head.appendChild(script);
}

// 呼叫載入 Google Maps API
loadGoogleMapsAPI();








//初始化地圖
function initMap() {
    map = new google.maps.Map(document.getElementById('map'), {
        center: { lat: 23.553118, lng: 121.0211024 },
        zoom: 7, // 地圖尺寸
    });
   

    // 呼叫載入 autocomplete
    autocomplete();
    textsearch(autocomplete);
}



//地圖搜尋Autocomplete
function autocomplete() {

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


        marker(autocomplete);//傳到marker
        textsearch(autocomplete);
    });

}





// 標記 Marker (新增標記，回傳 Marker)
function addMarker(place) {
    const marker = new google.maps.Marker({
        position: place.location,
        map: map,
    });

    markers.push(marker);
    return marker; // 回傳 marker，讓外部函式使用
}






// 綁定 InfoWindow，監聽「加入行程」按鈕
function setupInfoWindow(marker, place) {
    marker.addListener("click", function () {
        if (!infoWindow) {
            infoWindow = new google.maps.InfoWindow();
        }

        // 設定 `infoWindow` 內容
        infoWindow.setContent(`                  
            <h3>${place.name}</h3>
            <img src="${place.img}" style="height:250px">
            <div>地址：${place.address}</div>
            <div>電話：${place.phoneNumber}</div>
            <div>評分：${place.rating}</div>
            <div>營業時間：</div>
            <div>${place.opening}</div>
            <div>
                <button class="btn btn-primary mt-2" id="add-to-itinerary">
                    加入行程
                </button>
            </div>
        `);
        infoWindow.open(map, marker);

        // 確保 `infoWindow` DOM 元素載入後再綁定事件
        google.maps.event.addListenerOnce(infoWindow, "domready", () => {
            const addButton = document.getElementById("add-to-itinerary");
            if (addButton) {
                addButton.addEventListener("click", function () {
                    addToItinerary(place);
                });
            }
        });
    });
}





// 新增行程到資料庫
function addToItinerary(place) {
    fetch(`${baseAddress}/api/Places`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            date: 1,
            scheduleId: 1,
            name: place.name,
            address: place.address,
            latitude: place.lat,
            longitude: place.lng,
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
            itinerary.push(place);
            document.getElementById('search-input').value = ''; // 清空搜尋欄位
        })
        .catch(error => {
            console.error('儲存地點時發生錯誤：', error);
            alert('儲存地點時發生錯誤，請稍後再試。');
        });
}

// 標記 & 綁定監聽事件 (Main Function)
function marker(autocomplete) {
    autocomplete.addListener('place_changed', function () {
        const place = autocomplete.getPlace();

        if (!place.geometry || !place.geometry.location) {
            console.error("搜尋結果無法取得地點資訊");
            return;
        }

        const selectRestaurant = {
            location: place.geometry.location,
            placeId: place.place_id,
            name: place.name,
            address: place.formatted_address,
            lat: place.geometry.location.lat(),
            lng: place.geometry.location.lng(),
            phoneNumber: place.formatted_phone_number || "無資料",
            rating: place.rating || "無評分",
            img: place.photos[0].getUrl(),
            opening: place.current_opening_hours ? place.current_opening_hours.weekday_text : "無營業時間資訊",
        };

        // 將新地點加入陣列
        placesList.push(selectRestaurant);

        // **建立 Marker 並綁定 `infoWindow`**
        const newMarker = addMarker(selectRestaurant);


        setupInfoWindow(newMarker, selectRestaurant);

        // 設定地圖中心到新地點
        map.setCenter(selectRestaurant.location);
    });
}




// 清除標記
function clearMarkers() {
    markers.forEach((marker) => marker.setMap(null));
    markers = [];
}




// 模糊搜尋功能
function textsearch(autocomplete) {
    const service = new google.maps.places.PlacesService(map);

    autocomplete.addListener("place_changed", function () {
        const place = autocomplete.getPlace();
        const query = document.getElementById("textsearch-input").value.trim();

        if (!query) {
            alert("請輸入搜尋關鍵字！");
            return;
        }

        let searchLocation;
        if (place.geometry && place.geometry.location) {
            searchLocation = place.geometry.location; // 使用選擇的地點作為搜尋中心
        } else {
            searchLocation = map.getCenter(); // 若無選擇地點，使用當前地圖中心
        }

        // 使用 TextSearch 搜尋
        service.textSearch(
            {
                query: query,
                location: searchLocation,
                radius: 2000, // 搜尋半徑
                type: "restaurant",
            },
            function (results, status) {
                if (status === google.maps.places.PlacesServiceStatus.OK) {
                    clearMarkers(); // 清除舊標記

                    results.forEach((result) => {
                        const placeData = {
                            location: result.geometry.location,
                            placeId: result.place_id,
                            name: result.name,
                            address: result.formatted_address || "地址未知",
                            lat: result.geometry.location.lat(),
                            lng: result.geometry.location.lng(),
                            phoneNumber: result.formatted_phone_number || "無資料",
                            rating: result.rating || "無評分",
                            img: result.photos ? result.photos[0].getUrl() : "",
                            opening: place.current_opening_hours ? place.current_opening_hours.weekday_text : "無營業時間資訊",
                        };

                        const newMarker = addMarker(placeData); // 新增標記
                        setupInfoWindow(newMarker, placeData); // 綁定 `infoWindow`
                    });

                    // 設定地圖中心到搜尋地點
                    map.setCenter(searchLocation);
                } else {
                    alert("搜尋失敗：" + status);
                }
            }
        );
    });
}

















//模糊搜尋textsearch
//function textsearch(autocomplete) {
//    // 初始化 TextSearch 的服務
//    const service = new google.maps.places.PlacesService(map);

//    // 綁定 autocomplete 的 place_changed 事件
//    autocomplete.addListener('place_changed', function () {
//        const place = autocomplete.getPlace();
//        const query = document.getElementById('textsearch-input').value.trim(); // 從搜尋欄位獲取用戶輸入的關鍵字

//        if (!place.geometry || !place.geometry.location) {
//            console.error("選擇的地點無法取得經緯度");
//            return;
//        }

//        // 建立地點物件
//        const selectlocation = {
//            lat: place.geometry.location.lat(),
//            lng: place.geometry.location.lng(),
//        };

//        if (!query) {
//            alert("請輸入搜尋定位！");
//            return;
//        }

//        // 使用 TextSearch 搜尋地點
//        service.textSearch(
//            {
//                query: query, // 用戶輸入的搜尋關鍵字
//                location: { lat: selectlocation.lat, lng: selectlocation.lng }, // 使用用戶選擇的地點作為中心
//                radius: 2000, // 搜尋半徑（單位：公尺）
//                type: "restaurant", // 限定搜尋類型為餐廳
//            },
//            function (results, status) {
//                if (status === google.maps.places.PlacesServiceStatus.OK) {
//                    // 清除舊的標記
//                    clearMarkers();

//                    // 為每個搜尋結果添加標記
//                    results.forEach((result) => {
//                        addMarker(result.geometry.location, result.name);
//                    });
//                    marker(autocomplete);
           
//                } else {
//                    alert("搜尋失敗：" + status);
//                }
//            }
//        );
//    });

//    // 添加地圖標記的函數
//    function addMarker(location, title) {
//        const marker = new google.maps.Marker({
//            position: location,
//            map: map,
//            title: title,
//        });

//        markers.push(marker);
//    }

//    // 清除地圖標記的函數
//    function clearMarkers() {
//        markers.forEach((marker) => marker.setMap(null));
//        markers = [];
//    }
//}








//標記marker + 新增行程
// function marker(autocomplete) {
//     //載入地圖標記
//     autocomplete.addListener('place_changed', function () {
//         const place = autocomplete.getPlace();

//         // 檢查是否有地點資料
//         if (!place.geometry || !place.geometry.location) {
//             console.error("搜尋結果無法取得地點資訊");
//             return;
//         }

//         // 建立地點物件
//         const selectRestaurant = {
//             location: place.geometry.location,
//             placeId: place.place_id,
//             name: place.name,
//             address: place.formatted_address,
//             lat: place.geometry.location.lat(),
//             lng: place.geometry.location.lng(),
//             phoneNumber: place.formatted_phone_number || "無資料",
//             rating: place.rating || "無評分",
//             img: place.photos[0].getUrl(),
//             opening: place.current_opening_hours.weekday_text

//         };

//         // 將新地點加入陣列
//         placesList.push(selectRestaurant);

//         // 建立 marker
//         const marker = new google.maps.Marker({
//             position: selectRestaurant.location,
//             map: map,
//         });
//         markers.push(marker);
//         // 綁定 marker 點擊事件
//         marker.addListener("click", function () {
//             // 點擊時顯示對應地點的資訊
//             if (!infoWindow) {
//                 infoWindow = new google.maps.InfoWindow();
//             }
//             infoWindow.setContent(`                  
//                    <img src="${selectRestaurant.img} "style="height:250px">
//                    <h3>${selectRestaurant.name}</h3>
//                    <div>地址：${selectRestaurant.address}</div>
//                    <div>電話：${selectRestaurant.phoneNumber}</div>
//                    <div>評分：${selectRestaurant.rating}</div>
//                    <div>營業時間：</div>
//                    <div>${selectRestaurant.opening}</div>
//                    <div>
//                        <button class="btn btn-primary mt-2" id="add-to-itinerary">
//                            加入行程
//                        </button>
//                    </div>
//                `);
//             infoWindow.open(map, marker);
//             document.getElementById('search-input').value = '';//清空搜尋欄位
//             console.log(place);
//             // 監聽windowfo綁定加入行程按鈕
//             google.maps.event.addListenerOnce(infoWindow, "domready", () => {
//                 const addButton = document.getElementById("add-to-itinerary");
//                 addButton.addEventListener("click", function () {
//                     //// 新增行程進資料庫place
//                     if (selectRestaurant) {

//                         fetch(`${baseAddress}/api/Places`, {
//                             method: 'POST',
//                             headers: {
//                                 'Content-Type': 'application/json',
//                             },
//                             body: JSON.stringify({

//                                 date: 1,
//                                 scheduleId: 1,
//                                 name: selectRestaurant.name,    // 使用 selectRestaurant 的資料
//                                 address: selectRestaurant.address,
//                                 latitude: selectRestaurant.lat,  //來自 selectRestaurant 的緯度
//                                 longitude: selectRestaurant.lng//來自 selectRestaurant 的經度
//                             }),
//                         })
//                             .then(response => {
//                                 if (!response.ok) {
//                                     throw new Error(`HTTP error! status: ${response.status}`);
//                                 }
//                                 return response.json();
//                             })
//                             .then(data => {
//                                 console.log('地點已成功儲存：', data);
//                                 itinerary.push(selectRestaurant); // 更新前端行程陣列
//                                 document.getElementById('search-input').value = ''; // 清空搜尋欄位
//                             })
//                             .catch(error => {
//                                 console.error('儲存地點時發生錯誤：', error);
//                                 alert('儲存地點時發生錯誤，請稍後再試。'); // 顯示錯誤提示
//                             });
//                     }
//                     else {
//                         alert('請選擇一個地點！'); // 如果沒有選擇地點，提示用戶

//                     }
//                 });
//             });
//         });
//         // 設定地圖中心到新地點
//         map.setCenter(selectRestaurant.location);
//     });
//}
















//模糊搜尋
//async function searchPlaces() {
//    const request = {
//        textQuery: "墨西哥捲餅", // 查詢的文字
//        fields: ["displayName", "location", "businessStatus"], // 需要的欄位
//        includedType: "restaurant", // 包含的類型
//        locationBias: { lat: 23.6978, lng: 120.9605 }, // 台灣的中心經緯度
//        isOpenNow: true, // 只顯示營業中的地點
//        language: "zh-TW", // 繁體中文
//        maxResultCount: 8, // 最大回傳結果數量
//        minRating: 3.2, // 最低評分
//        region: "TW", // 區域設定為台灣
//        useStrictTypeFiltering: false, // 不使用嚴格類型篩選
//    };

//    try {
//        // 使用 Place API 搜尋
//        //@ts-ignore
//        const { places } = await Place.searchByText(request);

//        // 回傳結果處理
//        console.log("搜尋結果：", places);
//    } catch (error) {
//        console.error("搜尋時發生錯誤：", error);
//    }
//}







// 新增行程(已沒用)但目前刪除會有bug
document.getElementById('add').addEventListener('click', function () {
    if (selectRestaurant) {
        itinerary.push(selectRestaurant);
        localStorage.setItem('itinerary', JSON.stringify(itinerary));
        renderItinerary(itinerary);//重新渲染行程列表
        document.getElementById('search-input').value = '';//清空搜尋欄位

    }
});








// 顯示行程列表從資料庫
function renderItinerary(itinerary) {

    //console.log(`顯示行程列表從資料庫`);
    //console.log(itinerary);
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
function deleteplace(itinerary) {
document.getElementById('itinerary-list').addEventListener('click', function (e) {
    if (e.target.classList.contains('remove')) {
        const listItem = e.target.closest('li'); // 找到對應的 li
        const index = parseInt(listItem.getAttribute('data-index'), 10); // 取得 data-index 屬性
        const placeId = itinerary[index]?.id; // 確保有 ID

        if (!placeId) {
            console.error("無法刪除，因為找不到 placeId");
            return;
        }

        console.log(`刪除的行程索引: ${index}, ID: ${placeId}`);

        // 發送 API 請求刪除
        fetch(`${baseAddress}/api/Places/${placeId}`, {
            method: 'DELETE',
            headers: { 'Content-Type': 'application/json' },
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error('刪除失敗');
                }
                return response.json();
            })
            .then(() => {
                itinerary.splice(index, 1); // 從前端陣列刪除
                renderItinerary(itinerary); // 重新渲染 UI
                console.log(`成功刪除行程 ID: ${placeId}`);
            })
            .catch(error => console.error('刪除請求錯誤:', error));
    }
});

}





// 規劃路線從資料庫
function draw(itinerary) {
    console.log("規劃路線從資料庫");
    console.log(itinerary);



    // 將載入的資料轉換成行程格式
    itinerary = itinerary.map(item => ({
        id: item.id,
        location: { lat: item.latitude, lng: item.longitude },
        name: item.name,
        address: item.address,
    }));


    document.getElementById('draw-route').addEventListener('click', function () {

        if (!directionsService) directionsService = new google.maps.DirectionsService();

        directionsRenderers.forEach(renderer => renderer.setMap(null)); // 清除舊的路線
        directionsRenderers = [];

        const colors = ['#FF0000', '#0000FF', '#00FF00', '#FFA500', '#800080']; // 路線顏色清單

        for (let i = 0; i < itinerary.length - 1; i++) {
            const origin = itinerary[i].location;
            console.log(itinerary[i].location);
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

   


}




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





// 呼叫 API 取得資料庫place所有地點
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
        console.log("呼叫 API 取得資料庫place所有地點");
        console.log(data);  // 查看資料
        renderItinerary(data);  // 將資料傳遞給 renderItinerary
        draw(data); // 將資料傳遞給 draw
        deleteplace(data);
    })
    .catch(error => {
        console.error('Error fetching places:', error);  // 處理錯誤
    });




// 新增行程進資料庫place
//document.getElementById('add').addEventListener('click', function () {
//    if (selectRestaurant) {

//        fetch(`${baseAddress}/api/Places`, {
//            method: 'POST',
//            headers: {
//                'Content-Type': 'application/json',
//            },
//            body: JSON.stringify({

//                date: 1,
//                scheduleId: 1,
//                name: selectRestaurant.name,    // 使用 selectRestaurant 的資料
//                address: selectRestaurant.address,
//                latitude: selectRestaurant.lat,  //來自 selectRestaurant 的緯度
//                longitude: selectRestaurant.lng//來自 selectRestaurant 的經度
//            }),
//        })
//            .then(response => {
//                if (!response.ok) {
//                    throw new Error(`HTTP error! status: ${response.status}`);
//                }
//                return response.json();
//            })
//            .then(data => {
//                console.log('地點已成功儲存：', data);

//                itinerary.push(selectRestaurant); // 更新前端行程陣列

//                document.getElementById('search-input').value = ''; // 清空搜尋欄位
//            })
//            .catch(error => {
//                console.error('儲存地點時發生錯誤：', error);
//                alert('儲存地點時發生錯誤，請稍後再試。'); // 顯示錯誤提示

//            });
//    } else {
//        alert('請選擇一個地點！'); // 如果沒有選擇地點，提示用戶
//        renderItinerary(itinerary);
//    }
//});




renderItinerary(itinerary);


