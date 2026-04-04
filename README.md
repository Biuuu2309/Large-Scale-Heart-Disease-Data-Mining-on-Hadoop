# Khai thác dữ liệu lớn — Phân tích chỉ số bệnh tim (Heart Disease Indicators)

Dự án thực hành **khai thác và phân tích dữ liệu sức khỏe quy mô lớn**, sử dụng bộ dữ liệu khảo sát CDC về các chỉ số liên quan bệnh tim (phiên bản 2022, có giá trị thiếu). Luồng xử lý kết hợp **pipeline Spark trên HDFS** với **phân tích thống kê và trực quan hóa** trong Jupyter.

## Dữ liệu

- **Nguồn gợi ý**: [Personal Key Indicators of Heart Disease](https://www.kaggle.com/datasets/kamilpytlak/personal-key-indicators-of-heart-disease) (Kaggle).
- **File mẫu trong repo**: `data/heart_2022_with_nans.csv` (cần có tại đường dẫn tương ứng khi chạy; trong code có chỗ dùng `E:/Khaithacdulieulon/data/...`).

Các trường gồm thông tin nhân khẩu (bang, giới, nhóm tuổi, chủng tộc), chỉ số sức khỏe (BMI, ngày ốm thể chất/tinh thần, hút thuốc, tiền sử bệnh tim, đái tháo đường, v.v.).

## Công nghệ

| Thành phần | Vai trò |
|------------|---------|
| **Apache Hadoop 3.x** | HDFS lưu trữ dữ liệu dạng Parquet, phân vùng theo ngày |
| **Apache Spark (PySpark)** | Đọc/ghi CSV, Parquet; xử lý phân tán |
| **YARN** (tùy chọn) | Chạy Spark trên cluster; có script kiểm tra kết nối |
| **Python** | Pandas, NumPy, SciPy, Matplotlib, Seaborn, Plotly — EDA và mô hình thống kê trong notebook |

## Luồng xử lý dữ liệu (tóm tắt)

1. **Nạp CSV** → thêm cột metadata (`created_dateDL`, `updated_dateDL`) → **ghi Parquet lên HDFS** phân vùng theo `year` / `month` / `day` (`Program/main.py`).
2. **Đọc lại** từ HDFS để kiểm tra hoặc đếm bản ghi (`myjob.py`, `myjob_cluster.py`, `test_local.py`).
3. **Notebook** (`Program.ipynb`, `Main.ipynb`, …): đọc dữ liệu bằng Spark hoặc Pandas, làm sạch, ánh xạ biến, thống kê mô tả, kiểm định, biểu đồ.

## Cấu trúc thư mục liên quan

```
Khaithacdulieulon/
├── hadoop/                 # Cài đặt / cấu hình Hadoop (tham chiếu)
├── Program/
│   ├── main.py             # CSV → HDFS Parquet (partition theo ngày)
│   ├── myjob.py            # Đọc Parquet từ datalake, hiển thị mẫu
│   ├── myjob_cluster.py    # Đếm bản ghi trên HDFS (job cluster/YARN)
│   ├── test_local.py       # Spark local + đọc HDFS
│   ├── test_yarn.py        # Kiểm tra Spark với master yarn
│   ├── test_yarn_simple.py, test_yarn_connection.py
│   ├── fix_yarn.py         # Chẩn đoán nhanh YARN/Hadoop (Windows)
│   ├── Program.ipynb, Main.ipynb   # Phân tích chính
│   ├── Tutorial.ipynb, init__.ipynb, Fix.ipynb
│   └── Output/             # Kết quả xuất (CSV, txt)
├── data/                   # Đặt file CSV tại đây (hoặc chỉnh đường dẫn trong code)
├── Document/, Guide/, Report/, DTGK/   # Tài liệu / báo cáo bài tập
└── README.md
```

## Chạy nhanh (gợi ý)

1. Khởi động **HDFS** (và **YARN** nếu dùng cluster mode), đảm bảo NameNode lắng nghe đúng host/port (trong code có `hdfs://localhost:9000`).
2. Cài **Spark** có PySpark, biến môi trường `JAVA_HOME` và `HADOOP_HOME` đúng với môi trường Windows/Linux của bạn.
3. Chỉnh **đường dẫn file CSV** trong `main.py` (và notebook) cho khớp máy bạn.
4. Chạy pipeline nạp dữ liệu:
   ```bash
   spark-submit Program/main.py
   ```
   hoặc `python Program/main.py` tùy cách cấu hình Spark của bạn.

Các script `test_*.py` và `fix_yarn.py` dùng để xác minh Spark local, đọc HDFS, hoặc gỡ lỗi YARN trước khi chạy job nặng.

## Ghi chú

- Đường dẫn HDFS và đường dẫn file Windows trong notebook/script **cần thống nhất** theo môi trường triển khai.
- `Program.ipynb` chứa toàn bộ quy trình phân tích chi tiết; phần đầu notebook thể hiện tạo SparkSession, đọc CSV và thêm `PersonID` để quản lý bản ghi.

---

*Dự án phục vụ môn học / thực hành khai thác dữ liệu lớn với Hadoop & Spark.*
