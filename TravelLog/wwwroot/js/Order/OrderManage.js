async function cancelOrder(orderId) {
    if (!confirm("確定要取消這筆訂單嗎?")) return;

    const btnCancel = document.getElementById(`cancel-btn-${orderId}`);
    const statusElement = document.getElementById(`order-status-${orderId}`);
    const paymentStatusElement = document.getElementById(`payment-status-${orderId}`);

    try {
        // 禁用按鈕，防止重複點擊
        btnCancel.disabled = true;
        btnCancel.textContent = "取消中...";

        const response = await fetch("/Order/Cancel", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(orderId)
        });

        const result = await response.json();

        if (result.success) {
            alert("訂單取消成功！");

            // 更新 UI：顯示「已取消」
            if (statusElement) {
                statusElement.textContent = "已取消";
                statusElement.classList.remove("badge-primary", "badge-success");
                statusElement.classList.add("badge-danger");
            }

            // 更新 UI：顯示「已退款」
            if (paymentStatusElement) {
                paymentStatusElement.textContent = "已退款";
                paymentStatusElement.classList.remove("badge-primary", "badge-success");
                paymentStatusElement.classList.add("badge-info");
            }

            // 更新 UI：禁用按鈕
            btnCancel.textContent = "已取消";
            btnCancel.classList.remove("btn-danger");
            btnCancel.classList.add("btn-secondary");
            btnCancel.disabled = true;
        } else {
            alert(result.message || "取消失敗");
            btnCancel.disabled = false;
            btnCancel.textContent = "取消";
        }
    } catch (error) {
        console.error("取消訂單失敗:", error);
        alert("取消訂單失敗，請稍後再試");
        btnCancel.disabled = false;
        btnCancel.textContent = "取消";
    }
}
