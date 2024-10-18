import requests
import os
import sys

headers = {
    'Authorization': 'Token 15698ac529ea41bcb3d96aabf201eb3afe4801d2',
    'Accept': 'application/json',
}

# URL для отправки отчета
url = 'https://demo.defectdojo.org/api/v2/import-scan/'

# Путь к отчету
report_file_path = 'gitleaks.json'
# report_file_name = os.path.basename(report_file_path)
report_file_name = sys.argv[1]
report_scan_type = ''

if report_file_name == 'gitleaks.json':
    report_scan_type = 'Gitleaks Scan'
elif report_file_name == 'njsscan.sarif':
    report_scan_type = 'SARIF'
elif report_file_name == 'semgrep.json':
    report_scan_type = 'Semgrep JSON Report'

# Данные для отправки
files = {
    'file': (report_file_name, open(report_file_path, 'rb'), 'application/json'),
}

# Дополнительные параметры для отправки
data = {
    'active': True,
    'verified': True,
    'scan_type': report_scan_type,
    'minimum_severity': 'Low',
    'engagement': 28,  # Идентификатор вовлечения - https://demo.defectdojo.org/engagement/28
}

# Отправка POST-запроса
response = requests.post(url, headers=headers, files=files, data=data)

# Проверка ответа
if response.status_code == 201:
    print('Отчет успешно загружен.')
    print('Ответ:', response.json())
else:
    print('Ошибка при загрузке отчета:', response.status_code)
    print('Ответ:', response.text)
