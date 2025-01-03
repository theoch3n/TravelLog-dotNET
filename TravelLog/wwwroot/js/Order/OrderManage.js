async function cancelOrder(btnCancel) {

	if (!confirm('確定要取消這筆訂單嗎?'))
		return


	const orderId = btnCancel.dataset.orderId; // 從取消按鈕的 data-orderId 屬性獲取 orderId
	console.log("取消訂單 ID:", orderId); // 調試用
	const baseAddress = "https://localhost:7206";
	try {
		const response = await fetch(`${baseAddress}/Order/Cancel`, {
			method: "POST",
			headers: {
				"Content-Type": "application/json"
			},
			body: JSON.stringify(parseInt(orderId)) // 修正為直接傳遞整數
		});

		if (!response.ok) {
			throw new Error("Network response was not ok");
		}

		const result = await response.json();
		console.log("伺服器返回:", result); // 調試用

		if (result.success) {
			alert("訂單取消成功");

			// 更新頁面上的訂單狀態和取消日期
			document.getElementById("order-status-" + orderId).textContent = "4"; // 訂單取消
			document.getElementById("cancel-at-" + orderId).textContent = new Date().toLocaleString();
		} else {
			alert(result.message || "訂單取消失敗");
		}
	} catch (error) {
		console.error("訂單取消失敗:", error);
	}
}