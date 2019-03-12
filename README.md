# Инструменты управления инфраструктурой в Яндекс.Облаке

Данный репозиторий содержит в себе демонстрации, показанные на вебинаре "Инструменты управления инфраструктурой в Яндекс.Облаке"


## Начало работы

Для запуска тестовых инструментов

* Зарегистрируйтесь в [Яндекс.Облаке](https://cloud.yandex.ru)
* Установите и иницируйте [yc cli](https://cloud.yandex.ru/docs/cli/quickstart)
* Установите и иницируйте [terraform](https://www.terraform.io/downloads.html)
* Установите [go](https://www.terraform.io/downloads.html)
* (Для пользователей windows) установите [git-bash](https://gitforwindows.org)
* Сгенерируйте [ssh ключ](https://git-scm.com/book/ru/v1/Git-на-сервере-Создание-открытого-SSH-ключа) для доступа к инстансам
* Добавьте себе следующие переменные окружения:
export YC_TOKEN=<ВАШ oauth token> - ссылку на него можно получить выполнив 'yc init')
export YC_CLOUD_ID=<ID вашего облака> - посмотреть можно [тут](https://console.cloud.yandex.ru/?section=info)
export YC_FOLDER=<ID вашего folder> - можно получить выполнив 'yc resource-manager folder list'


## Демонстрации


* [yc cli](01-cli/)
* [terraform](02-terraform/)
* [REST API](03-rest/)
* [GO SDK](04-go/)
