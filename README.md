# Инструменты управления инфраструктурой в Яндекс.Облаке

Данный репозиторий содержит в себе демонстрации, показанные на вебинаре ["Инструменты управления инфраструктурой в Яндекс.Облаке"](https://www.youtube.com/watch?v=gGJHS2jRROQ)
Основная цель - познакомить вас с инструментами работы с облаком.

SDK и примеры для GO и Python доступны в [официальном репозитории Яндекс Облака](https://github.com/yandex-cloud)


## Начало работы

Для запуска тестовых инструментов

* Зарегистрируйтесь в [Яндекс.Облаке](https://cloud.yandex.ru)
* Создайте себе фолдер под демонстрацию 
* Установите и иницируйте [yc cli](https://cloud.yandex.ru/docs/cli/quickstart)
* Запишите id вашего фолдера, облака и ваш токен, выполнив `yc config list`
* Установите и иницируйте [terraform](https://www.terraform.io/downloads.html)
* (Для пользователей windows) установите [git-bash](https://gitforwindows.org) и делайте все задания из под него
* Сгенерируйте [ssh ключ](https://git-scm.com/book/ru/v1/Git-на-сервере-Создание-открытого-SSH-ключа) для доступа к инстансам
* Скачайте репозиторий с помощью git
```
git clone https://github.com/nar3k/yc-automation.git
cd yc-automation
```


## Демонстрации


Задания выполняются в указанном ниже порядке. Просто перейдите по ссылке на первое задание и увидите все инструкции

1. [yc cli](docs/01-cli/README.md)
2. [terraform](docs/02-terraform/README.md)
3. [REST API](docs/03-rest/README.md)
4. [Удаление инфраструктуры](docs/04-delete/README.md)
