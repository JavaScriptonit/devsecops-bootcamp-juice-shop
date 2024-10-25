FROM node:18 as installer
COPY . /juice-shop
WORKDIR /juice-shop
RUN npm i -g typescript ts-node
RUN npm install --omit=dev --unsafe-perm
RUN npm dedupe
RUN rm -rf frontend/node_modules
RUN rm -rf frontend/.angular
RUN rm -rf frontend/src/assets
RUN mkdir logs
RUN chown -R 65532 logs
RUN chgrp -R 0 ftp/ frontend/dist/ logs/ data/ i18n/
RUN chmod -R g=u ftp/ frontend/dist/ logs/ data/ i18n/
RUN rm data/chatbot/botDefaultTrainingData.json || true
RUN rm ftp/legal.md || true
RUN rm i18n/*.json || true

FROM node:18-bookworm-slim
WORKDIR /juice-shop
COPY --from=installer --chown=65532:0 /juice-shop .
USER 65532
EXPOSE 3000
CMD ["/juice-shop/build/app.js"]



























# ======================================================================

# FROM node:18 as installer
# # Использует образ Node.js версии 18 в качестве базового образа для этой сборки и задает имя "installer" для последующего использования.

# COPY . /juice-shop
# # Копирует все файлы и папки из текущего каталога на хосте в каталог /juice-shop внутри контейнера.

# WORKDIR /juice-shop
# # Устанавливает рабочий каталог для последующих команд на /juice-shop. Это означает, что все команды `RUN`, `CMD`, `ENTRYPOINT`, `COPY` и `ADD` будут выполняться из этого каталога.

# RUN npm i -g typescript ts-node
# # Устанавливает TypeScript и ts-node (для выполнения TypeScript файлов) глобально.

# RUN npm install --omit=dev --unsafe-perm
# # Устанавливает все зависимости проекта, за исключением зависимостей для разработки (devDependencies). Флаг `--unsafe-perm` позволяет выполнять скрипты установки с повышенными привилегиями.

# RUN npm dedupe
# # Упрощает дерево зависимостей, удаляя дублирующиеся пакеты и устанавливая только одну копию каждого пакета, если это возможно.

# RUN rm -rf frontend/node_modules
# # Удаляет каталог node_modules в директории frontend, вероятно, для предотвращения конфликтов или потому что он будет пересоздан позже.

# RUN rm -rf frontend/.angular
# # Удаляет каталог .angular из frontend, чтобы избежать оставшихся артефактов сборки Angular.

# RUN rm -rf frontend/src/assets
# # Удаляет каталог src/assets из frontend, возможно, чтобы уменьшить размер образа или потому что эти активы не нужны в финальном контейнере.

# RUN mkdir logs
# # Создает каталог logs, который, вероятно, будет использоваться для хранения логов приложения.

# RUN chown -R 65532 logs
# # Изменяет владельца каталога logs (и всех его содержимого) на UID 65532 (обычно используется для не привилегированных пользователей).

# RUN chgrp -R 0 ftp/ frontend/dist/ logs/ data/ i18n/
# # Устанавливает группу для указанных каталогов (ftp/, frontend/dist/, logs/, data/ и i18n/) на GID 0 (обычно это группа root).

# RUN chmod -R g=u ftp/ frontend/dist/ logs/ data/ i18n/
# # Устанавливает права доступа для указанных каталогов, задавая группе те же права, что и у владельца (равные).

# RUN rm data/chatbot/botDefaultTrainingData.json || true
# # Удаляет файл data/chatbot/botDefaultTrainingData.json, если он существует; в противном случае игнорирует ошибку.

# RUN rm ftp/legal.md || true
# # Удаляет файл ftp/legal.md, если он существует; в противном случае игнорирует ошибку.

# RUN rm i18n/*.json || true
# # Удаляет все файлы с расширением .json в каталоге i18n, если они существуют; в противном случае игнорирует ошибку.

# FROM node:18-bookworm-slim
# # Начинает новый этап сборки с нового базового образа Node.js версии 18 (slim версия), который будет более компактным.

# WORKDIR /juice-shop
# # Устанавливает рабочий каталог для следующего этапа на /juice-shop.

# COPY --from=installer --chown=65532:0 /juice-shop .
# # Копирует все файлы из этапа "installer" и устанавливает владельца (UID 65532) и группу (GID 0) для всех файлов.

# USER 65532
# # Переключает пользователя контейнера на пользователя с UID 65532 для выполнения приложений с меньшими правами (без привилегий).

# EXPOSE 3000
# # Указывает, что контейнер слушает на порту 3000 во время выполнения. Это объявление помогает в документации и сетевых настройках, но не открывает порты.

# CMD ["/juice-shop/build/app.js"]
# # Определяет команду, которая будет выполнена, когда контейнер будет запущен. В данном случае это установка команды для запуска приложения Node.js.
