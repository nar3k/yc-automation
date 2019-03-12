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
* Скачайте репозиторий с помощью git
```
git clone https://github.com/nar3k/yc-automation.git
cd yc-automation
```


## Демонстрации

Скачиваем репозиторий
Для каждой демонстрации переключаемся в соотвествтующую папку. Задания лучше выполнять по порядку

1. [yc cli](docs/01-cli/README.md)
2. [terraform](docs/02-terraform/README.md)
3. [REST API](docs/03-rest/README.md)
4. [Удаление инфраструктуры](docs/04-delete/README.md)
