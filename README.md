Файлы для разработки модулей Puppet 3.8 под Vagrant на базе Centos 7.

Требования:
* Установленный ***virtualbox 4 (!)***
* Включенная виртуализация в BIOS
* Установленный Vagrant
* Установленный плагин hostmanager (vagrant plugin install vagrant-hostmanager)
* Доступ в интернет

Запуск виртуальных машин:
* git clone
* vagrant up
* vagrant ssh puppet

История изменений:  
v1.0.0 Первая версия  
* Реализован функционал запуска конфигурации агент-мастер
* Автоматическая стартовая установка агент, мастера
* Обновление агента раз в 30 секунд
* Выключен firewall на агенте и мастере
* Пароль для пользователя vagrant - 123
* Обновление ОС до версии на момент запуска
* Временная зона выставлена в Europe/Moscow
* Включено разделение на environments, создано окружение production с пустым site.pp в котором указана только одна нода agent
