async function cancelOrder(btnCancel) {

    if (!confirm('確定要取消這筆訂單嗎?'))
        return


    const orderId = btnCancel.dataset.orderId; // 從取消按鈕的 data-orderId 屬性獲取 orderId
    console.log("取消訂單 ID:", orderId); // 調試用
    const baseAddress = "https://localhost:7206";
    try {
        // 禁用取消按鈕，防止重複點擊
        btnCancel.disabled = true;
        //btnCancel.textContent = '取消中...';

        const response = await fetch(${ baseAddress } / Order / Cancel, {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(parseInt(orderId))
        });

        if (!response.ok) {
            throw new Error(HTTP error! status: ${ response.status });
        }

        const result = await response.json();
        console.log("伺服器返回:", result);

        if (result.success) {
            // 使用更友好的狀態顯示
            const statusMap = {
                4: '已取消'
            };

            const orderStatusElement = document.getElementById("order-status-" + orderId);
            const cancelAtElement = document.getElementById("cancel-at-" + orderId);

            if (orderStatusElement) {
                orderStatusElement.textContent = statusMap[4] || '已取消';
                orderStatusElement.classList.add('text-danger');
            }

            if (cancelAtElement) {
                cancelAtElement.textContent = new Date().toLocaleString();
            }

            // 禁用取消按鈕
            btnCancel.disabled = true;
            btnCancel.classList.remove('btn-outline-danger');
            btnCancel.classList.add('btn-secondary');
            btnCancel.textContent = '已取消';

            alert("訂單取消成功");
        } else {
            alert(result.message || "訂單取消失敗");
            // 恢復按鈕狀態
            btnCancel.disabled = false;
            btnCancel.textContent = '取消訂單';
        }
    } catch (error) {
        console.error("訂單取消失敗:", error);
        alert("訂單取消失敗，請稍後再試");
        // 恢復按鈕狀態
        btnCancel.disabled = false;
        btnCancel.textContent = '取消訂單';
    }
}