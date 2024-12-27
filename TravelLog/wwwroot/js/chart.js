const ctx = document.getElementById('myChart'); // 圖表預計插入位置

new Chart(ctx, {
    type: 'bar',
    data: {
        labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
        datasets: [{
            label: '2024 年每月遊客數',
            data: [109, 98, 77, 136, 201, 156, 311, 114, 165, 175, 89, 211],
            borderWidth: 1
        }]
    },
    options: {
        scales: {
            y: {
                beginAtZero: true
            }
        }
    }
});