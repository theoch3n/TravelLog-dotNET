async function cancelOrder(orderId) {
	try {
		const response = await fetch(Url.Action("Cancel", "Order"), {
			method: "POST",
			headers: {
				"Content-Type": "application/json"
			},
			body: JSON.stringify({id:orderId})
		});

		if (!response.ok) {
			throw new Error("Network response was not ok");
		}

		const result = await response.json();

		if (result.success) {
			alert("訂單取消成功");

			// 更新頁面上的訂單狀態和取消日期
			document.getElementById("order-status-" + orderId).textContent = "4"; // 訂單取消
			document.getElementById("cancel-at-" + orderId).textContent = new Date().toLocaleString();
		} else {
			alert("訂單取消失敗");
		}
	} catch (error) {
		console.error("取消訂單失敗:", error);
	}
}