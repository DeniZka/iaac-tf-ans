# iaac-tf-ans
Terraform &amp; Ansible infrastucture

### requiered packages
1. [ansible](https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html)
2. [terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

### before start
Run `make configure` to prepare environment

### apply IaaC
Run `make apply` for terraform and ansible


### Как эта "шляпа" устроена

Тут на русском, чтобы враг не догадался. Конечно.

Когда пишешь `make configure` производится настройка кружения
1. Копируется местный открытый ключ на Jump Host (сам proxmox). 
Тут понадобится пароль root
2. Копируется местный открытй ключ в список ключей для машин инфраструктуры
3. Настраивается файл .env с переменными среды для terraform и ansible и прочих нужд.
Тут нужно будет указать API token ID и SECRET, которые будет занесены в .env
4. Скачивется плагин для terraform с обходом санкций и проводится инициализация терраформа
5. Узнается ауктуальная версия mysql для последующей автоустановки

Так же можно конфирурировать все по отдельности `make configure-<WHAT-FOR>`

Теперь можно закатывать `make apply`. Тут происходит следующая магия
1. Читается .env и все переменны экспортируются для всех процессов
2. Запускается терраформ из каталога `/terraform`
3. Терраформ выполняет модули `main.tf`, читая их из шаблонов в `bms-devops`
4. Потом передает на провижн `ansible` обратно через `make`.
Это удобно, если нужно прокатить провижн отдельно без ожидания окончания терраформирования.
Так как все переменные на борту пишем `make play <book-name>.yml`. 
Где book-name совпадает с именем хоста
5. Книги ансибла отыгрываются по корфигурируемым ролям-шаблонам


### Как добавить новый нод и провижн для него

Терраформ и ансибл взаимозавязаны через `host_name` в модулях `main.tf`.
Так что имя машины тащим через всё

1. В файле `terraform/main.tf` прописать новый модуль.
2. Запустить `make init`, иначе терраформ не желает с новыми модулями работать
3. В файле `ansible/inveintory/hosts` в раздел `nodes` прописать `host_name`
с указанием IP, как и в `main.tf` 
4. В каталоге `ansible/` создать `<host_name>.yml`
5. В каталоге `ansible/roles` создать роль `ansible-galaxy init <role-name>`
5. Запустить `make apply`
**Пунты 3, 4, 5 могут выполняться в автоматическом режиме.**
**Если роль существует после `make init` можно юзать `make apply`**
**Если нет, то создастся пустой шаблон выбранной роли**



